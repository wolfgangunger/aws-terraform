project = "nxp-partner-network"
environment = "prod"
aspnetcore_env = "nxp-partner-prod"
db_user = "admin"
route53_domain = "prod.eimex-solutions.de"
use_existing_route53_zone = false
shared_loadbalancer_arn = "arn:aws:elasticloadbalancing:eu-central-1:034839930720:loadbalancer/app/shared-load-balancer/d7e20f8cc623d831"
app_instance_arn = "arn:aws:chime:us-east-1:034839930720:app-instance/31d4eb8e-db2b-4285-9722-2d03bb1bea69"
app_instance_arn_user = "arn:aws:chime:us-east-1:034839930720:app-instance/31d4eb8e-db2b-4285-9722-2d03bb1bea69/user/AdminArn"
urls = {
    "admin" = "admin.nxp.partner.prod.eimex-solutions.de"
    "visitors" = "visitors.nxp.partner.prod.eimex-solutions.de"
    "admin-api" = "admin-webapi.nxp.partner.prod.eimex-solutions.de"
    "visitors-api" = "visitors-webapi.nxp.partner.prod.eimex-solutions.de"
}
