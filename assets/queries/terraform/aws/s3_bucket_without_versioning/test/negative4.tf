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

resource "aws_s3_bucket_logging" "bucket_logging_example" {
  count  = 1

  bucket = aws_s3_bucket.bucket_with_count[count.index].id

  target_bucket = "bucket_where_we_want_amazon_s3_to_store_server_access_logs"
  target_prefix = "prefix/for/all/log/object/keys/"
}
