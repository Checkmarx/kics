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

resource "aws_s3_bucket" "public-bucket" {
  bucket = "bucket-with-public-acl-3"
  acl = "public-read-write"
}

resource "aws_s3_bucket_public_access_block" "block_public_bucket_3" {
  bucket = aws_s3_bucket.public-bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
