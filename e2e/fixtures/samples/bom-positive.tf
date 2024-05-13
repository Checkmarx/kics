module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket = "my-s3-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }
}


resource "aws_athena_database" "hoge" {
  name   = "database_name"
  bucket = aws_s3_bucket.hoge.bucket
}
