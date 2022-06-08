terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_s3_bucket" "bu2" {
  bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_acl" "example_bucket_acl2" {
  bucket = aws_s3_bucket.bu2.id
  acl = "public-read-write"
}

resource "aws_s3_bucket_public_access_block" "block_public_bucket_322" {
  bucket = aws_s3_bucket.bu2.id
  block_public_acls = false
  block_public_policy = true
  ignore_public_acls = false
  restrict_public_buckets = true
}
