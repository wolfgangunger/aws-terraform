module "webapi_cert" {
  source = "terraform-aws-modules/acm/aws"

  zone_id = local.zone_id

  domain_name = "admin-webapi.nxp.partner.${local.domain_name}"
  subject_alternative_names = [
    "visitors-webapi.nxp.partner.${local.domain_name}"
  ]
}

module "cloudfront_cert" {
  source = "terraform-aws-modules/acm/aws"

  providers = {
    aws = aws.us-east
  }

  zone_id = local.zone_id

  domain_name = "admin.nxp.partner.${local.domain_name}"
  subject_alternative_names = [
    "visitors.nxp.partner.${local.domain_name}"
  ]
}
