// Define Terraform required providers with version constraints.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}

// Configure the S3 backend for storing Terraform state.
terraform {
  backend "s3" {
    bucket = "tfstate-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}

// Provider configuration for AWS with local testing settings.
provider "aws" {

  // AWS access keys for testing purposes.
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"

  // Use path-style endpoint for S3.
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    // LocalStack S3 endpoint.
    s3       = "http://s3.localhost.localstack.cloud:4566"
  }
}