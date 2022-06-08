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

resource "aws_s3_bucket" "mybucket2" {
  bucket = "my-tf-example-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example3" {
  bucket = aws_s3_bucket.mybucket2.bucket

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
    }
  }
}
