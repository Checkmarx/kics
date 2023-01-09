terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_s3_bucket" "mybucket22" {
  count  = 1
  bucket = "my-tf-example-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example33" {
  count  = 1
  bucket = aws_s3_bucket.mybucket22[count.index].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
