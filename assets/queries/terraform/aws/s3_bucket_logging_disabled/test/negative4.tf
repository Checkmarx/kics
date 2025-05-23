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

resource "aws_s3_bucket" "bucket_with_count" {
  count  = 1

  bucket = "my-tf-test-bucket-with-count"

  tags = {
    Name        = "My awesome bucket with count"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning_example" {
  count  = 1

  bucket = aws_s3_bucket.bucket_with_count[count.index].id

  versioning_configuration {
    status = "Enabled"
  }
}
