locals {
  # Use existing (via data source) or create new zone (will fail validation, if zone is not reachable)
  use_existing_route53_zone = var.use_existing_route53_zone

  domain = var.route53_domain

  # Removing trailing dot from domain - just to be sure :)
  domain_name = trimsuffix(local.domain, ".")

  zone_id = try(data.aws_route53_zone.this[0].zone_id, aws_route53_zone.this[0].zone_id)
}

data "aws_route53_zone" "this" {
  count = local.use_existing_route53_zone ? 1 : 0

  name         = local.domain_name
  private_zone = false
}

resource "aws_route53_zone" "this" {
  count = !local.use_existing_route53_zone ? 1 : 0

  name = local.domain_name
}

resource "aws_route53_record" "admin_frontend" {
  zone_id = aws_route53_zone.this[0].id
  name    = var.urls["admin"]
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.admin.domain_name]
}

resource "aws_route53_record" "visitors_frontend" {
  zone_id = aws_route53_zone.this[0].id
  name    = var.urls["visitors"]
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.visitors.domain_name]
}

locals {
  apis = ["admin-api", "visitors-api"]
}

data "aws_lb" "alb" {
  arn = try(module.application_load_balancer[0].lb_arn, var.shared_loadbalancer_arn)
}

resource "aws_route53_record" "api_records" {
  for_each = toset(local.apis)

  zone_id = aws_route53_zone.this[0].id
  name    = var.urls["${each.value}"]
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_lb.alb.dns_name]
}
