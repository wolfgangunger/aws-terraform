module "beanstalk_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${var.project}-${var.environment}-beanstalk-security-group"
  description = "Security group allowing traffic to and from Elastic Beanstalk."
  vpc_id      = data.aws_vpc.default.id

  egress_rules = ["all-all"]

  #   ingress @TODO: We should try to secure it better...
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

resource "aws_elastic_beanstalk_application" "this" {
  name = "${var.project}-${var.environment}-beanstalk-application"
}

data "aws_elastic_beanstalk_solution_stack" "this" {
  most_recent = true

  name_regex = "^64bit Amazon Linux 2 (.*) running .NET Core$"
}

resource "aws_elastic_beanstalk_environment" "admin_area" {
  application         = aws_elastic_beanstalk_application.this.name
  cname_prefix        = "${var.project}-${var.environment}-admin"
  description         = "Beanstalk environment for admin area."
  name                = "${var.project}-${var.environment}-admin"
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.this.name
  tier                = "WebServer"

  # lifecycle {
  #   ignore_changes = [
  #     setting
  #   ]
  # }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "IgnoreHealthCheck"
    value     = true
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/health"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "7"
  }

  # Environment variables passed to the application.

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ASPNETCORE_ENVIRONMENT"
    value     = var.aspnetcore_env
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__AccessKey"
    value     = aws_iam_access_key.admin_area.id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__SecretKey"
    value     = aws_iam_access_key.admin_area.secret
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__AccountId"
    value     = data.aws_caller_identity.current.account_id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__ChimeConfiguration__AppInstanceAdminArn"
    value     = var.app_instance_arn_user
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__ChimeConfiguration__AppInstanceArn"
    value     = var.app_instance_arn
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__ChimeConfiguration__IdentityPoolId"
    value     = aws_cognito_identity_pool.this.id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__Issuer"
    value     = "https://${aws_cognito_user_pool.this.endpoint}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__MediaConvertConfiguration__OutputFolder"
    value     = var.media_convert_output_folder
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__MediaConvertConfiguration__Role"
    value     = aws_iam_role.media_convert_service_role.arn
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__Region"
    value     = data.aws_region.current.name
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__S3BucketName"
    value     = aws_s3_bucket.assets_and_content.id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__S3BucketUrlPattern"
    value     = var.s3_bucket_url_pattern
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__S3FolderName"
    value     = var.s3_folder_name
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__UserPoolClientId"
    value     = aws_cognito_user_pool_client.admin_area_webapi.id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS__UserPoolId"
    value     = aws_cognito_user_pool.this.id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ClientConfiguration__ResetPasswordConfirmUrl"
    value     = "https://${var.urls["admin"]}/auth/password-reset/reset"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ClientConfiguration__SignUpConfirmUrl"
    value     = "https://${var.urls["admin"]}/auth/sign-up-confirm"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "FEVisitorAreaDomainAddress"
    value     = "https://${var.urls["visitors"]}/aws"
  }
  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name = "SignalRHubConfiguration__DomainAddress"
  #   value = var.signalr_url
  # }
  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name = "SignalRHubConfiguration__MessageHubPath"
  #   value = var.signalr_hub_path
  # }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ConnectionStrings__DefaultConnection"
    value     = "Server=${module.db.db_instance_address};port=${module.db.db_instance_port};User Id=${module.db.db_instance_username};Password=${module.db.db_instance_password};Database=${replace(local.db_name, "-", "_")};charset=utf8;Allow User Variables=True"
  }
  # File size limits
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "FileSizeInMegaBytes"
    value     = var.file_size_in_megabytes
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ImageFileSizeInMegaBytes"
    value     = var.image_file_size_in_megabytes
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "UserConfiguration__MaxUserProfileFileSizeInMegaBytes"
    value     = var.max_user_profile_size
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MediaLibraryConfiguration__MaxFileSizeInMegaBytes"
    value     = var.media_library_image_file_size_in_megabytes
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "HeroGalleryConfiguration__MaxFileSizeInMegaBytes"
    value     = var.hero_gallery_max_file_size_in_megabytes
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "StreamingModuleConfiguration__MaxStreamingFileSizeInMegaBytes"
    value     = var.max_streaming_file_size_in_megabytes
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "StreamingModuleConfiguration__MaxImageFileSizeInMegaBytes"
    value     = var.max_streaming_image_file_size_in_megabytes
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EventsConfiguration__MaxBinaryAdditionFileSizeInMegaBytes"
    value     = var.max_binary_addition_file_size_in_megabytes
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SpacesConfiguration__MaxPreviewImageFileSizeInMegaBytes"
    value     = var.max_preview_image_file_size_in_megabytes
  }

  # Load balancer settings

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk.name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = module.beanstalk_security_group.security_group_name
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerIsShared"
    value     = true
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SharedLoadBalancer"
    value     = var.shared_loadbalancer_arn == null ? module.application_load_balancer[0].lb_arn : var.shared_loadbalancer_arn
  }
  # Rules for listener on port 443
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Rules"
    value     = "httpsrule"
  }
  setting {
    namespace = "aws:elbv2:listenerrule:httpsrule"
    name      = "HostHeaders"
    value     = var.urls["admin-api"]
  }
  setting {
    namespace = "aws:elbv2:listenerrule:httpsrule"
    name      = "Priority"
    value     = 2
  }
  # Rules for listener on port 80
  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "Rules"
    value     = "httprule"
  }
  setting {
    namespace = "aws:elbv2:listenerrule:httprule"
    name      = "HostHeaders"
    value     = var.urls["admin-api"]
  }
  setting {
    namespace = "aws:elbv2:listenerrule:httprule"
    name      = "Priority"
    value     = 1
  }
}
