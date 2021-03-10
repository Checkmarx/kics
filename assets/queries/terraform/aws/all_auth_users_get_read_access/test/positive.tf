resource "aws_s3_bucket" "positive1" {
  bucket = "my-tf-test-bucket"
  acl    = "authenticated-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}