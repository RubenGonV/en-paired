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
}

output "bucket_name" {
  value       = aws_s3_bucket.fastapi_bucket.bucket
  description = "Nombre del bucket S3 creado para la app FastAPI"
}
