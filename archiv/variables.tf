variable "project" {
  description = "Name of the project environment is created for"
  type        = string
}
variable "environment" {
  description = "Name of the environment"
  type        = string
  validation {
    condition     = contains(["dev", "prod", "qa", "stage"], var.environment)
    error_message = "The environment must be one of dev, qa, stage, prod."
  }
}
variable "use_existing_route53_zone" {
  description = "Specifiy if new DNS zone should be created or should existing one should be used."
  type        = bool
}
variable "route53_domain" {
  description = "Domain to be used for this environment. Will be created in route53. Ex: stage.eimex-solutions.de"
  type        = string
}
variable "aspnetcore_env" {
  type        = string
  description = "Variable passed to tho dotnet application"
}
variable "db_user" {
  description = "Name of the admin user for the database"
  type        = string
  default     = "admin"
}
variable "app_instance_arn" {
  description = "Arn of chime app instance."
  type        = string
}
variable "app_instance_arn_user" {
  description = "Arn of chime app instance user."
  type        = string
}
# variable "cloudfront_certificate" {
#   description = "ACS certificate ARN that will handle TLS connecitons to the frontend. Remember that certificate needs to be created in us-east-1 region."
#   type        = string
# }
# variable "alb_certificate_arn" {
#   description = "ARN of the certificate for port 443 listener in ALB. At least one certificate needs to be attached to ALB in order for resource creation to proceed."
#   type        = string
# }
variable "shared_loadbalancer_arn" {
  description = "ARN of the shared load balancer that is already present in the account. If variable is left empty it will be created."
  type        = string
  default     = null
}
variable "urls" {
  description = "URLs for the application endpoints."
  type        = map(any)
}
variable "media_convert_output_folder" {
  description = "Output folder for media convert service"
  type        = string
  default     = "hlsvideo"
}
variable "s3_bucket_url_pattern" {
  description = "S3 bucket url pattern."
  type        = string
  default     = "https://{0}.s3.{1}.amazonaws.com/{2}"
}
variable "s3_folder_name" {
  description = "Folder name for S3 bucket"
  type        = string
  default     = "assets"
}
variable "file_size_in_megabytes" {
  description = "Max file size in megabytes"
  type        = string
  default     = "1200"
}
variable "hero_gallery_max_file_size_in_megabytes" {
  description = "Hero gallery max file size in megabytes"
  type        = string
  default     = "1200"
}
variable "image_file_size_in_megabytes" {
  description = "Max image file size in megabytes"
  type        = string
  default     = "600"
}
variable "max_user_profile_size" {
  description = "Max user's profile size in megabytes"
  type        = string
  default     = "50"
}
variable "media_library_image_file_size_in_megabytes" {
  description = "Max media library image file size in megabytes"
  type        = string
  default     = "1200"
}
variable "max_streaming_file_size_in_megabytes" {
  description = "Max streaming file size in megabytes"
  type        = string
  default     = "1200"
}
variable "max_streaming_image_file_size_in_megabytes" {
  description = "Max streaming image file size in megabytes"
  type        = string
  default     = "1200"
}
variable "max_binary_addition_file_size_in_megabytes" {
  description = "Max binary addition file size in megabytes"
  type        = string
  default     = "1200"
}
variable "max_preview_image_file_size_in_megabytes" {
  description = "Max preview image file size in megabytes"
  type        = string
  default     = "200"
}
