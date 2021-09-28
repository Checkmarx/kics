module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "0.0.1"
  bucket = "s3-tf-example-versioning"
  acl    = "private"
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }

  versioning_inputs = [
    {
      enabled = true
      mfa_delete = null
    },
  ]
}
