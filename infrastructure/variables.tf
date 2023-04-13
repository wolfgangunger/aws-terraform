variable "project_name" {
  type        = string
  default     = ""
  description = "Name used for prefix resources"
}

variable "owner" {
  description = "Owner name for tag resources"
  type        = string
}

variable "environment_name" {
  type        = string
  description = "Environment name (dev|qa|stage|prod)"
  validation {
    condition     = contains(["dev", "prod", "qa", "stage"], var.environment_name)
    error_message = "The environment must be one of dev, qa, stage, prod."
  }
}

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "role_arn" {
  description = "Admin Role ARN used to create resources in the account"
  type        = string
}

variable "admin_arns" {
  type        = list(string)
  default     = [""]
  description = "List of iam user arns that can assume the admin role of this account"
}


variable "readonly_arns" {
  type        = list(string)
  default     = [""]
  description = "List of iam user arns that can assume the readonly role of this account"
}

variable "class_B" {
  type        = number
  default     = 100
  description = "Class B of VPC (10.XXX.0.0/16)"
}
