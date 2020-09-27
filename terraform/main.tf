# -----------------------------------------------------------------------------
# variables
# -----------------------------------------------------------------------------

variable "static_files_in_bucket" {
  description = "1- static files are uploaded into the S3 bucket. 0- static files are removed"
  default     = 1
}

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
  count  = var.static_files_in_bucket
  bucket = aws_s3_bucket.lpiot_bucket.bucket
  key    = "index.html"
  source = "../resources/index.html"
  acl    = "public-read"
  etag = filemd5("../resources/index.html")
}

resource "aws_s3_bucket_object" "static_www_error" {
  count  = var.static_files_in_bucket
  bucket = aws_s3_bucket.lpiot_bucket.bucket
  key    = "error.html"
  source = "../resources/error.html"
  acl    = "public-read"
  etag = filemd5("../resources/error.html")
}

