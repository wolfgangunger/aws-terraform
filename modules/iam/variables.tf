variable admin_arns {
  type    = list(string)
  description = "List of iam user arns that can assume the admin role of this account"
}

variable "readonly_arns" {
  type        = list(string)
  default     = [""]
  description = "List of iam user arns that can assume the readonly role of this account"
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