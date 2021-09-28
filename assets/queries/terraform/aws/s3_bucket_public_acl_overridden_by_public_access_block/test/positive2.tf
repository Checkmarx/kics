resource "aws_s3_bucket" "public-bucket4" {
  bucket = "bucket-with-public-acl-32"
  acl = "public-read-write"
}


module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket = aws_s3_bucket.public-bucket4.id
  create_bucket=false

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::my_tf_test_bucket/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}
