# Terraform

## Deploying infrastructure

Easiest way to deploy is to run:

```bash
terraform init
terraform plan
terraform apply -var-file dev.tfvars
```
Where `*.tfvars` file is the place for storing required variables. 

If the files is not provided Terraform will query for required variables during the run.
## Manual steps:

- [ ] ~~If running on new account, create, validate and provide ACM certificate arn. This certificate need to be in the same region as ALB.~~
- [ ] ~~Specify existing ALB Arn in variables.~~
- [ ] ~~Create and validate ACM certificate for cloudfront in us-east-1 region.~~
- [ ] Create arn and app instance arn and provide as variables. (This is temporary as better workaround is still being worked on.)
- [ ] ~~Create route53 redirects to proper app endpoints. This is only relevant if using eimex domain, as separate accounts handles it. Still working on a workaround.~~

## TODO:

- [x] Azure release pipeline integration
- [ ] ~~Attach unverified ACM certificate to cloudfront - not possible~~
- [x] Attaching API ACM certificates and handling verification.
- [x] Handle DNS hosted zone creation.
- [ ] Variables restrictions
- [ ] Try to fix Beanstalk env terraform bug
- [ ] Make this into module
- [ ] Terratest for testing the code in the future?
