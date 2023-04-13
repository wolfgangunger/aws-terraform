terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket  = "eimex-nxp-prod-terraform"
    key     = "prod/tfstate"
    region  = "eu-central-1"
  }
}

provider "aws" {
  region  = "eu-central-1"
}

provider "aws" {
  region  = "us-east-1"
  alias   = "us-east"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
} 

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
