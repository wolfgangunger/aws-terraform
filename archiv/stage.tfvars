project = "nxp-partner-network"
environment = "stage"
aspnetcore_env = "nxp-partner-stage"
db_user = "admin"
route53_domain = "stage.eimex-solutions.de"
use_existing_route53_zone = false
# shared_loadbalancer_arn = null
app_instance_arn = "arn:aws:chime:us-east-1:034839930720:app-instance/e9b729ea-9760-4c6d-ac43-e1bda008ce7e"
app_instance_arn_user = "arn:aws:chime:us-east-1:034839930720:app-instance/e9b729ea-9760-4c6d-ac43-e1bda008ce7e/user/AdminArn"
urls = {
    "admin" = "admin.nxp.partner.stage.eimex-solutions.de"
    "visitors" = "visitors.nxp.partner.stage.eimex-solutions.de"
    "admin-api" = "admin-webapi.nxp.partner.stage.eimex-solutions.de"
    "visitors-api" = "visitors-webapi.nxp.partner.stage.eimex-solutions.de"
}
