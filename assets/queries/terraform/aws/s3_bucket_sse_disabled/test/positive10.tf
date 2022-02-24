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

resource "aws_s3_bucket" "mybucket22" {
  bucket = "my-tf-example-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example33" {
  bucket = aws_s3_bucket.mybucket22.bucket

  rule {
    bucket_key_enabled = false
  }
}
