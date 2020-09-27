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
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "static_www_index" {
  bucket = aws_s3_bucket.lpiot_bucket.bucket
  key    = "index.html"
  source = "../resources/index.html"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "static_www_error" {
  bucket = aws_s3_bucket.lpiot_bucket.bucket
  key    = "error.html"
  source = "../resources/error.html"
  acl    = "public-read"
}

