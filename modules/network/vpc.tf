module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "${var.project_name}-vpc"
  cidr = "10.${var.class_B}.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.${var.class_B}.1.0/24", "10.${var.class_B}.2.0/24", "10.${var.class_B}.3.0/24"]
  public_subnets  = ["10.${var.class_B}.101.0/24", "10.${var.class_B}.102.0/24", "10.${var.class_B}.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "${var.environment_name}"
    Owner = "${var.owner}"
  }
}