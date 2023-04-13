terraform {

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = var.role_arn
  }
}


module "iam" {
  source = "../modules/iam"

  admin_arns       = var.admin_arns
  readonly_arns    = var.readonly_arns
  owner            = var.owner
  environment_name = var.environment_name
}

module "network" {
  source = "../modules/network"

  class_B          = var.class_B
  project_name     = var.project_name
  owner            = var.owner
  environment_name = var.environment_name
  aws_region       = var.aws_region
}







