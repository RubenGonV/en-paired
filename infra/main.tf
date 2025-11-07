terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "fastapi_bucket" {
  bucket = "fastapi-app-${random_id.suffix.hex}"

  tags = {
    Name = "en-paired-fastapi-bucket"
    Project = "en-paired"
  }
}

# Block all public access (security best practice)
resource "aws_s3_bucket_public_access_block" "fastapi_bucket" {
  bucket = aws_s3_bucket.fastapi_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning (FREE - only pay for storage)
resource "aws_s3_bucket_versioning" "fastapi_bucket" {
  bucket = aws_s3_bucket.fastapi_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption (AES256 is FREE)
resource "aws_s3_bucket_server_side_encryption_configuration" "fastapi_bucket" {
  bucket = aws_s3_bucket.fastapi_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
