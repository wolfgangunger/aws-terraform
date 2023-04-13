resource "aws_cognito_identity_pool" "this" {
  identity_pool_name               = "Identity pool for ${var.project} ${var.environment}"
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.admin_area_webapi.id
    provider_name = aws_cognito_user_pool.this.endpoint
  }

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.visitors_area_webapi.id
    provider_name = aws_cognito_user_pool.this.endpoint
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "this" {
  identity_pool_id = aws_cognito_identity_pool.this.id
  roles = {
    "authenticated"   = aws_iam_role.cognito_auth_role.arn
    "unauthenticated" = aws_iam_role.cognito_unauth_role.arn
  }
}

resource "aws_cognito_user_pool_client" "admin_area_webapi" {
  user_pool_id                                  = aws_cognito_user_pool.this.id
  name                                          = "admin-area-webapi"
  allowed_oauth_flows_user_pool_client          = "false"
  enable_propagate_additional_user_context_data = "false"
  enable_token_revocation                       = "false"
  explicit_auth_flows                           = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH"]
  prevent_user_existence_errors                 = "ENABLED"
  read_attributes                               = ["address", "birthdate", "custom:userStatus", "custom:AppInstanceUserArn", "custom:UserAvailableStatus", "custom:activityTimestamp", "custom:application", "custom:company", "custom:country", "custom:division", "custom:interest", "custom:language", "custom:position", "email", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  write_attributes                              = ["address", "birthdate", "custom:userStatus", "custom:AppInstanceUserArn", "custom:UserAvailableStatus", "custom:activityTimestamp", "custom:application", "custom:company", "custom:country", "custom:division", "custom:interest", "custom:language", "custom:position", "email", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  auth_session_validity                         = "3"
  id_token_validity                             = "1"
  access_token_validity                         = "1"
  refresh_token_validity                        = "30"

  token_validity_units {
    access_token  = "days"
    id_token      = "days"
    refresh_token = "days"
  }

}

resource "aws_cognito_user_pool_client" "visitors_area_webapi" {
  user_pool_id                                  = aws_cognito_user_pool.this.id
  name                                          = "visitors-area-webapi"
  allowed_oauth_flows_user_pool_client          = "false"
  enable_propagate_additional_user_context_data = "false"
  enable_token_revocation                       = "false"
  explicit_auth_flows                           = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH"]
  prevent_user_existence_errors                 = "ENABLED"
  read_attributes                               = ["address", "birthdate", "custom:userStatus", "custom:AppInstanceUserArn", "custom:UserAvailableStatus", "custom:activityTimestamp", "custom:application", "custom:company", "custom:country", "custom:division", "custom:interest", "custom:language", "custom:position", "email", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  write_attributes                              = ["address", "birthdate", "custom:userStatus", "custom:AppInstanceUserArn", "custom:UserAvailableStatus", "custom:activityTimestamp", "custom:application", "custom:company", "custom:country", "custom:division", "custom:interest", "custom:language", "custom:position", "email", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  auth_session_validity                         = "3"
  id_token_validity                             = "1"
  access_token_validity                         = "1"
  refresh_token_validity                        = "30"

  token_validity_units {
    access_token  = "days"
    id_token      = "days"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool" "this" {

  name                = "${var.project}-${var.environment}-cognito-pool"
  deletion_protection = "ACTIVE"
  mfa_configuration   = "OFF"

  auto_verified_attributes = ["email"]

  lambda_config {
    custom_message = module.cognito_message_handler.lambda_function_arn
  }

  username_configuration {
    case_sensitive = "false"
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = "1"
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = "2"
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = "false"
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    minimum_length                   = "8"
    require_lowercase                = "true"
    require_numbers                  = "true"
    require_symbols                  = "true"
    require_uppercase                = "true"
    temporary_password_validity_days = "7"
  }

  ### User attirbutes:
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "AppInstanceUserArn"
    required                 = "false"

    string_attribute_constraints {
      max_length = "1600"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "UserAvailableStatus"
    required                 = "false"

    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "activityTimestamp"
    required                 = "false"

    string_attribute_constraints {
      max_length = "120"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "application"
    required                 = "false"

    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "company"
    required                 = "false"

    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "country"
    required                 = "false"

    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "division"
    required                 = "false"

    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "email"
    required                 = "true"

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "interest"
    required                 = "false"

    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "language"
    required                 = "false"

    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "position"
    required                 = "false"

    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = "false"
    mutable                  = "true"
    name                     = "userStatus"
    required                 = "false"

    string_attribute_constraints {
      max_length = "120"
      min_length = "1"
    }
  }
}
