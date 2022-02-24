provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

resource "aws_s3_bucket" "example1" {
  bucket = "my-tf-example-bucket"
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.example1.id
  acl    = "authenticated-read"
}
