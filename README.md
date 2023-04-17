# Terraform

A sample project to show terraform setup

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
           │           ├── dev.tfvars  
           │           ├── qa.tfvars  
           │           └── prod.tfvars  
           └── main.tf  
           └── variables.tf             

the infrastructure folder holds the the main.tf file  
inside the env folders are the variables and config files  
  
the resources are grouped in the modules folders  

the project will create IAM roles for your environment ( AdminRole and ReadOnlyRole).
this arns should point to valid iam user in your master account. if you got a single account setup, to the iam user in this account.  
you can define the members by variables: admin_arns & readonly_arns
  
it will also create a vpc for your. you can define the Class B in the variables: class_B  = 100
CIDR Range will be :  "10.${var.class_B}.0.0/16"  

This is a basic setup for the first to layers of your infrastructure, IAM & VPC.
Feel free to add more modules with your databases, applications etc   
  
## Manual steps:
Deploy Terraform Bootstrap CFN Template  
you have to insert these parameters:  
-a list of IAM users, you want to add to the role, must be valid principals ( from your master account)   
 format is : arn:aws:iam::xxxxxxxx:user/youruserid
-env name, to choose from  
-owner name, select your name for example   
-project name, whatever your want to use, will be used in the bucket name and dynamo

Take a look in the CFN Stack and under resources see the created aws-resources:
AWS::S3::Bucket  
AWS::DynamoDB::Table  
AWS::IAM::Role  

This will create the S3 Bucket and Policy and DynamoDB for the Terraform state, also Terraform Role.
      
Adapt the backend.conf file and enter the correct variables for :
role_arn       = "arn:aws:iam::xxxxxxxx:role/TerraformRole"
bucket         = "tf-state-terrafrom-sample-wu-dev-xxxxxx"
dynamodb_table = "tf-state-lock-terrafrom-sample-wu-dev"
region         = "eu-central-1"
key            = "terraform.tfstate"

Adapt the qa.tfvars file :  
aws_region       = "eu-central-1"  
environment_name = "qa"  
class_B          = 100  
project_name     = "qa-project"  
owner            = "wolfgang.unger"  
role_arn         = "arn:aws:iam::xxxxxx:role/TerraformRole"  

## aws configure
run aws configure:   
in multi account environment add role_arn to your profile   
must look some like this:   
[default]
region = eu-central-1  
source_profile = default  
role_arn = arn:aws:iam::xxxx:role/TerraformRole (or the role you are alredy using by switch role) 
output = json  
  
## Deploying infrastructure with terafrom  
First init:  
terraform init -backend-config="env/qa-backend.conf"  
  
Plan:  
terraform plan -var-file env/qa.tfvars    
Apply:    
terraform apply -var-file env/qa.tfvars    
Destroy:  
terraform destroy -var-file env/qa.tfvars    





