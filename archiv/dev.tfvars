project = "nxp-partner-network"
environment = "dev"
aspnetcore_env = "nxp-partner-dev"
db_user = "admin"
shared_loadbalancer_arn = "arn:aws:elasticloadbalancing:eu-central-1:506710974040:loadbalancer/app/Shared-ALB/efd1dfe22b5b01d5"
alb_certificate_arn = "arn:aws:acm:eu-central-1:506710974040:certificate/d76f3db7-02a4-44ea-b171-304278eb66ca"
urls = {
    "admin" = "admin.nxp.partner.dev.eimex-solutions.de"
    "visitors" = "visitors.nxp.partner.dev.eimex-solutions.de"
    "admin-api" = "admin-webapi.nxp.partner.dev.eimex-solutions.de"
    "visitors-api" = "visitors-webapi.nxp.partner.dev.eimex-solutions.de"
}
cloudfront_certificate = "arn:aws:acm:us-east-1:506710974040:certificate/302d45f0-abba-4147-9c34-b5e98cef951d"
