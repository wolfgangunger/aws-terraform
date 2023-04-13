#########################################################
# Account Info
#########################################################
# Name : NXP Event QA
# Account No: 519389025541
# Email:  nxp.event.qa@eimex-solutions.com
# CICD: 10.100.0.0/16



aws_region       = "eu-central-1"
environment_name = "qa"
class_B          = 100
project_name     = "nxp-event-qa"
owner            = "soeren.fricke"
role_arn         = "arn:aws:iam::519389025541:role/TerraformRole"


admin_arns = [
  "arn:aws:iam::770687811207:user/daniel.nascimento@sccbrasil.com",
  "arn:aws:iam::770687811207:user/wolfgang.unger@sccbrasil.com",
  "arn:aws:iam::770687811207:user/jonas.tokmaji@seracom.de"
]

readonly_arns = [
  "arn:aws:iam::770687811207:user/daniel.nascimento@sccbrasil.com",
  "arn:aws:iam::770687811207:user/wolfgang.unger@sccbrasil.com",
  "arn:aws:iam::770687811207:user/jonas.tokmaji@seracom.de"
]
