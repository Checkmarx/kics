module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  version = "3.7.0"

  bucket = "my-s3-bucket"
  acl    = "public-read-write"

  versioning = {
    enabled = true
  }

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

}
