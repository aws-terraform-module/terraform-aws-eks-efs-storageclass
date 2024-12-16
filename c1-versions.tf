# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
     }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    } 
  }
  # Adding Backend as S3 for Remote State Storage
  # backend "s3" {
  #   bucket = "terraform-on-aws-eks-nim"
  #   key    = "dev/efs-sampleapp-demo/terraform.tfstate"
  #   region = "us-east-1" 

  #   # For State Locking
  #   dynamodb_table = "dev-efs-sampleapp-demo"    
  # }    
}

