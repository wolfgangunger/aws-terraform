# Admin area frontend bucket
# TODO: Fix this map and reference in cloudfront
locals {
  buckets = [
    "${var.project}-${var.environment}-admin-frontend",
    "${var.project}-${var.environment}-visitors-frontend"
  ]
}

resource "aws_s3_bucket" "frontend_buckets" {
  for_each = toset(local.buckets)

  bucket              = each.value
  object_lock_enabled = "false"
}

resource "aws_s3_bucket_policy" "this" {
  for_each = aws_s3_bucket.frontend_buckets
  bucket   = each.key
  policy   = data.aws_iam_policy_document.allow_access[each.key].json
}

data "aws_iam_policy_document" "allow_access" {
  for_each = aws_s3_bucket.frontend_buckets

  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.frontend_buckets[each.key].arn,
      "${aws_s3_bucket.frontend_buckets[each.key].arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "assets_and_content" {

  bucket              = "${var.project}-${var.environment}-assets-and-content-bucket"
  object_lock_enabled = "false"
}

resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = aws_s3_bucket.assets_and_content.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.assets_and_content.id

  lambda_function {
    lambda_function_arn = module.profile_image_thumbnailer.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "profiles/"
  }

  depends_on = [module.profile_image_thumbnailer]
}

resource "aws_s3_bucket_policy" "assets_and_content" {
  bucket = aws_s3_bucket.assets_and_content.id
  policy = data.aws_iam_policy_document.allow_access_assets_and_content.json
}

data "aws_iam_policy_document" "allow_access_assets_and_content" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.assets_and_content.arn,
      "${aws_s3_bucket.assets_and_content.arn}/*"
    ]
  }
}

# Chat attachment bucket

resource "aws_s3_bucket" "chat_attachements" {
  bucket              = "${var.project}-${var.environment}-chat-attachements-bucket"
  object_lock_enabled = "false"
}

data "aws_iam_policy_document" "chat_attachments_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]

    resources = ["${aws_s3_bucket.chat_attachements.arn}/protected/$${cognito-identity.amazonaws.com:sub}/*"]
  }
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.chat_attachements.arn}/protected/*"
    ]
  }
}

data "aws_iam_policy_document" "chime_chat_user_policy" {
  statement {
    actions = [
      "chime:GetMessagingSessionEndpoint"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "cognito-idp:ListUsers"
    ]
    resources = [aws_cognito_identity_pool.this.arn]
  }
  statement {
    actions = [
      "chime:SendChannelMessage",
      "chime:ListChannelMessages",
      "chime:GetChannelMessage",
      "chime:CreateChannelMembership",
      "chime:ListChannelMemberships",
      "chime:DeleteChannelMembership",
      "chime:Connect",
      "chime:ListChannelMembershipsForAppInstanceUser",
      "chime:CreateChannel",
      "chime:DeleteChannel",
      "chime:DescribeChannel",
      "chime:UpdateChannel"
    ]
    resources = [
      "${var.app_instance_arn}/user/*",
      "${var.app_instance_arn}/user/${aws_cognito_user_pool.this.id}:*",
      "${var.app_instance_arn}/channel/*"
    ]
  }
}
data "aws_iam_policy_document" "cognito_authorized_policy" {
  statement {
    actions = [
      "chime:GetMessagingSessionEndpoint"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "mobileanalytics:PutEvents",
      "cognito-sync:*",
      "cognito-identity:*"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cognito_unauthorized_policy" {
  statement {
    actions = [
      "mobileanalytics:PutEvents",
      "cognito-sync:*"
    ]
    resources = ["*"]
  }
}

