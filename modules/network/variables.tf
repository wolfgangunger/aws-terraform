variable project_name {
  description = "Project or Client name used to prefix resources"
  type        = string
}

variable owner {
  description = "Owner name for tag resources"
  type        = string
}

variable environment_name {
  type        = string
  default     = ""
  description = "dev/stage/prod"
}

variable aws_region {
  type        = string
  default     = "eu-central-1"
  description = "AWS Region"
}

variable class_B {
  type        = number
  default     = 1
  description = "Class B of VPC (10.XXX.0.0/16)"
}