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

# -----------------------------------------------------------------------------
# EC2 AMI
# -----------------------------------------------------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
 }

 owners = ["099720109477"] # Canonical
}

# -----------------------------------------------------------------------------
# EC2 Instances
# -----------------------------------------------------------------------------

resource "aws_instance" "dockercoins_rng" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.dockercoins_keypair.key_name
  security_groups = [ aws_security_group.allow_ssh.name ]
  tags = {
    Project = "DockerCoins"
    Owner   = "lpiot"
  }
}

# -----------------------------------------------------------------------------
# Security groups
# -----------------------------------------------------------------------------

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  ingress {
    description = "Allows SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["51.255.70.100/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "allow_ssh"
    Project = "DockerCoins"
    Owner   = "lpiot"
  }
}

# -----------------------------------------------------------------------------
# EC2 Key/Pair
# -----------------------------------------------------------------------------

resource "aws_key_pair" "dockercoins_keypair" {
  key_name   = "dockercoins_keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkEY7em/6ywpKoxSI7v3uQjQCfTfMJWZYT5nD2r00ZU47n3myLohiy8hSuB0IGual6uT56zTd7QMSVHEa0Sn2uSZArwCOQxLUWccki5fJnT2S4WfGjwikgF922bC5HKqLrQdV4lNcr8b8WDkgETBwqIB0BnlVaPEwNzQP8J45tTrEBctRsfoo8zqhyXj2gRCTTx7wYECOMSh6ww9lI7wEEXxs8AjzWtcuNIQmAMp+uk7eAKXtEe6CfmRumthsXBNMhuj3ZfGKelebUvXA80V/ARETGRT3mnO1n7JsybPWk8AzqCamDj/L7U5pjEeACpApAlOJJ58NOQKOQJGG/8W5+vcARcyarDPgN6SPy8KOBk94ro6U/TjigHHxj1+/l4vedF7SNDXq/kJChL3oZC8+/tMlq5vRN+8q64D1dEt4jL+OZJyZn6MDsdk464ejNCHZSUVe5z+LREVup4ISfWaU24UWfhLwElqcSBsC68LCXcgDc4KjRS2HZ/S/d70C+ljVTDaBmMKKxlsllnQz/J7rEwMXz5v6eCoQQdeTWIBkUNU9nqIU0kI3aQfAeF4wgDdzyinrmWtSy1NosWJAT2gtuccfqBEit9pz6cl4GtepjOfmjlagBNuBgbzcxn8EfI8+zmcA7CmLMrzoKEpE+/ktJYdaqR5PpRxE0TDzEa5sGNQ== ludovic@glamdring"
  tags = {
    Project = "DockerCoins"
    Owner   = "lpiot"
  }
}

