//comment to offset
resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  acl    = "website"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }
}