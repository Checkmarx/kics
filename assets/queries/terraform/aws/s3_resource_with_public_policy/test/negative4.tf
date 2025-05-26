module "s3_account" {
  source = "terraform-aws-modules/s3-account/aws"
  version = "3.7.0"

  bucket = "my-s3-account"
  acl    = "private"
  restrict_public_buckets = true
  block_public_acls = true
  block_public_policy = true

  versioning = {
    enabled = true
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYACCOUNTPOLICY",
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
