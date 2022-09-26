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


module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  versioning = {
    enabled = true
  }

  bucket = "my_bucket"
  acl    = "public-read"
}

resource "aws_cloudtrail" "foobar2" {
  name                          = "tf-trail-foobar"
  s3_bucket_name                = aws_s3_bucket.bb.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "bb" {
  bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bb.id
  acl    = "public-read"
}
