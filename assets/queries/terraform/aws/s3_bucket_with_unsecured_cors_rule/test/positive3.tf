module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "s3-tf-example-versioning"
  acl    = "private"
  version = "0.0.1"
  
  versioning = [
    {
      enabled = true
      mfa_delete = null
    },
  ]

  cors_rule = [
   {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
   }
  ]
}
