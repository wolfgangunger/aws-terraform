############### Admin Role #####################
data "aws_iam_policy_document" "admin_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.admin_arns
    }
  }
}

resource "aws_iam_role" "admin_role" {
  name               = "AdminRole"
  assume_role_policy = data.aws_iam_policy_document.admin_assume_role_policy.json

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
    Owner       = "${var.owner}"
  }
}

resource "aws_iam_role_policy_attachment" "attach_admin_policy_to_role" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

############### ReadOnly Role #####################
data "aws_iam_policy_document" "readonly_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.admin_arns
    }
  }
}

resource "aws_iam_role" "readonly_role" {
  name               = "ReadOnlyRole"
  assume_role_policy = data.aws_iam_policy_document.readonly_assume_role_policy.json

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
    Owner       = "${var.owner}"
  }
}

resource "aws_iam_role_policy_attachment" "attach_readonlys_policy_to_role" {
  role       = aws_iam_role.readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


