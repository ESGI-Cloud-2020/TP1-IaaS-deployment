# -----------------------------------------------------------------------------
# provider
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "default"
  shared_credentials_file = "/root/.aws/credentials"
}

# -----------------------------------------------------------------------------
# static website
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "lpiot_bucket" {
  bucket = "s3-website-test.esgi.lpiot"
  acl    = "public-read"
}

