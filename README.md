# Terraform

## Strucure
└── terraform/  
   ├── modules/  
   │   ├── network/  
   │   │   ├── main.tf  
   │   │   ├── dns.tf  
   │   │   ├── outputs.tf  
   │   │   └── variables.tf  
   │   └── iam/  
   │       ├── main.tf  
   │       ├── outputs.tf  
   │       └── variables.tf  
   │   └── more-modules/  
   └── infrastructure/  
       ├── env/  
           ├──── nxp-event/  
           │           ├── dev.tfvars  
           │           ├── qa.tfvars  
           │           └── prod.tfvars  
           ├──── nxp-aws-partner/  
           │           ├── dev.tfvars  
           │           ├── qa.tfvars  
           │           └── prod.tfvars  
           └── main.tf  
           └── variables.tf             

the infrastructure folder holds the the main.tf file  
inside the env folders are the variables and config files  
  
the resources are grouped in the modules folders  

## Manual steps:
Deploy Terraform Bootstrap CFN Template  
This will create the S3 Bucket and Policy and DynamoDB for the Terraform state, also Terraform Role  

## Deploying infrastructure

First init:  
terraform init -backend-config="env/nxp-event/nxp-event-qa-backend.conf"  
  
Plan:  
terraform plan -var-file dev.tfvars  
terraform plan -backend-config="env/nxp-event/nxp-event-qa-backend.conf"  
Apply:  
terraform apply -var-file dev.tfvars  
terraform apply -backend-config="env/nxp-event/nxp-event-qa-backend.conf"  





