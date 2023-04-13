resource "aws_iam_role" "beanstalk_instance_profile" {
  name                 = "${var.project}-${var.environment}-beanstalk-instance-role"
  path                 = "/"
  max_session_duration = "3600"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonChimeFullAccess",
    "arn:aws:iam::aws:policy/AmazonChimeSDK",
    "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
  ]

  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  inline_policy {
    name   = "EbApp"
    policy = "{\"Statement\":[{\"Action\":\"*\",\"Resource\":\"*\",\"Effect\":\"Allow\"}]}"
  }

}

resource "aws_iam_instance_profile" "beanstalk" {
  name = "${var.project}-${var.environment}-app-instance-profile"
  path = "/"
  role = aws_iam_role.beanstalk_instance_profile.name
}

resource "aws_iam_role" "media_convert_service_role" {
  name                 = "media-convert-service-role-${var.project}-${var.environment}"
  path                 = "/service-role/"
  max_session_duration = "3600"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
  ]

  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "mediaconvert.amazonaws.com"
      }
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_iam_user" "admin_area" {
  force_destroy = "false"
  name          = "${var.project}-${var.environment}-admin-user"
  path          = "/"
}

resource "aws_iam_user_policy_attachment" "admin_user_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonCognitoPowerUser",
    "arn:aws:iam::aws:policy/AmazonChimeFullAccess",
    "arn:aws:iam::aws:policy/AWSElementalMediaConvertFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonChimeSDK"
  ])
  user = aws_iam_user.admin_area.name
  policy_arn = each.value
}

resource "aws_iam_user_policy" "streaming_policy" {
  name = "StreamingPolicy"
  user = aws_iam_user.admin_area.name

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ivs:ListChannels",
        "ivs:GetChannel",
        "ivs:CreateChannel",
        "ivs:DeleteChannel",
        "ivs:ListStreams",
        "ivs:GetStreamKey"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_access_key" "admin_area" {
  user = aws_iam_user.admin_area.name
}

resource "aws_iam_role" "cognito_auth_role" {
  name                 = "${var.project}-${var.environment}-cognito-auth-role"
  max_session_duration = "3600"
  path                 = "/"

  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        },
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.this.id}"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  inline_policy {
    name   = "${var.project}-${var.environment}-chime-chat-policy"
    policy = data.aws_iam_policy_document.chime_chat_user_policy.json
  }
  inline_policy {
    name   = "${var.project}-${var.environment}-cognito-authorized-policy"
    policy = data.aws_iam_policy_document.cognito_authorized_policy.json
  }
  inline_policy {
    name   = "${var.project}-${var.environment}-chat-attachements-policy"
    policy = data.aws_iam_policy_document.chat_attachments_policy.json
  }

}

resource "aws_iam_role" "cognito_unauth_role" {
  name                 = "${var.project}-${var.environment}-cognito-unAuth-role"
  max_session_duration = "3600"
  path                 = "/"

  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        },
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.this.id}"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  inline_policy {
    name   = "${var.project}-${var.environment}-CognitoUnauthorizedPolicy"
    policy = data.aws_iam_policy_document.cognito_unauthorized_policy.json
  }

}
