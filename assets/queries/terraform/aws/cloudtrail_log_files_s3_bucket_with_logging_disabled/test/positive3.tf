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

resource "aws_cloudtrail" "foobar2" {
  name                          = "tf-trail-foobar"
  s3_bucket_name                = aws_s3_bucket.bb.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "bb" {
  bucket = "my-tf-example-bucket"
}
