//comment
resource "aws_s3_bucket" "negative1" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  logging {
    target_bucket = "logs"
  }

  versioning {
    mfa_delete = true
  }
}