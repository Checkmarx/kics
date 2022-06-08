provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
resource "aws_s3_bucket" "public-bucket2" {
  bucket = "bucket-with-public-acl-32"
  acl = "public-read-write"
}

resource "aws_s3_bucket_public_access_block" "block_public_bucket_32" {
  bucket = aws_s3_bucket.public-bucket2.id
  block_public_acls = false
  block_public_policy = true
  ignore_public_acls = false
  restrict_public_buckets = true
}
