#########################################################
# Account Info
#########################################################
# Name : QA Account
# Account No: XXX
# Email:  my@email.com
# CICD: 10.101.0.0/16



aws_region       = "eu-central-1"
environment_name = "qa"
class_B          = 101
project_name     = "qa-project"
owner            = "wolfgang.unger"
role_arn         = "arn:aws:iam::243277030071:role/TerraformRole"

## add admins for your environment
admin_arns = [
  "arn:aws:iam::039735417706:user/admin"
]
# add user for read only access
readonly_arns = [
  "arn:aws:iam::039735417706:user/admin"
]
