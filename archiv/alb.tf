module "alb_security_group" {
  count = "${var.shared_loadbalancer_arn == null ? 1 : 0}"

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"


  name        = "${var.project}-${var.environment}-alb-security-group"
  description = "Security group allowing traffic on ALB."
  vpc_id      = data.aws_vpc.default.id

  egress_rules = ["all-all"]

  #   ingress @TODO: We should try to secure it better...
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "application_load_balancer" {
  count = "${var.shared_loadbalancer_arn == null ? 1 : 0}"

  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "shared-load-balancer"

  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.default.id
  subnets         = data.aws_subnets.this.ids
  security_groups = [data.aws_security_group.default.id, module.alb_security_group[0].security_group_id]


  # @TODO: Work on enabling this
  #   access_logs = {
  #     bucket = "my-alb-logs"
  #   }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.webapi_cert.acm_certificate_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed message"
        status_code  = "503"
      }
    }
  ]
}

data "aws_lb_listener" "_443" {
  load_balancer_arn = try(module.application_load_balancer[0].lb_arn, var.shared_loadbalancer_arn)
  port              = 443
}

resource "aws_lb_listener_certificate" "prod" {
  listener_arn    = data.aws_lb_listener._443.arn
  certificate_arn = module.webapi_cert.acm_certificate_arn
}
