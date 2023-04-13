module "cognito_message_handler" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.project}-${var.environment}-cognito-message-handler"
  description   = "Cognito message handler"
  handler       = "main.handler"
  runtime       = "nodejs12.x"

  publish = true

  source_path = [
    {
      path             = "../lambdas/cognitoMessageHandler/dist",
      npm_requirements = false
    }
  ]
  allowed_triggers = {
    CognitoTrigger = {
      principal  = "cognito-idp.amazonaws.com"
      source_arn = aws_cognito_user_pool.this.arn
    }
  }
  environment_variables = {
    ENV          = var.environment
    SERVICE_TYPE = var.project
  }
}
module "chime-app-instance-creator" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.project}-${var.environment}-chime-app-instance-creator"
  description   = "Chime App instance creator"
  handler       = "main.handler"
  runtime       = "nodejs12.x"

  source_path = [
    {
      path             = "../lambdas/chimeAppInstanceCreator/dist"
      npm_requirements = false
    }
  ]
}
module "profile_image_thumbnailer" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.project}-${var.environment}-profile-image-thumbnailer"
  description   = "Profile image thumbnailer"
  handler       = "main.handler"
  runtime       = "nodejs12.x"

  publish = true
  
  source_path = "../lambdas/profileImageThumbnailer"

  allowed_triggers = {
    S3Trigger = {
      principal  = "s3.amazonaws.com"
      source_arn = aws_s3_bucket.assets_and_content.arn
    }
  }
}
