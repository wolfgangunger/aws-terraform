locals {
  db_instance_name = "${var.project}-${var.environment}-database-instance"
  db_name          = "${var.project}-${var.environment}-admin"
}

resource "random_password" "master_password" {
  length  = 20
  special = false
}

resource "aws_secretsmanager_secret" "db_pass" {
  name = "${var.project}-${var.environment}-db-password"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.db_pass.id
  secret_string = random_password.master_password.result
}


module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.db_instance_name

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t4g.small"
  allocated_storage = 5

  db_name  = replace(local.db_name, "-", "_")
  username = var.db_user
  port     = "3306"
  password = random_password.master_password.result


  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole-${var.project}-${var.environment}"
  create_monitoring_role = true

  # Do not generate password for db.
  create_random_password = false

  publicly_accessible = true

  vpc_security_group_ids = [module.security_group.security_group_id]

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.this.ids

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection 
  deletion_protection = false
  skip_final_snapshot = true
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${var.project}-${var.environment}-db-security-group"
  description = "MySQL databse security group"
  vpc_id      = data.aws_vpc.default.id

  # ingress @TODO: We should try to secure it better...
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_rules = ["all-all"]
}
