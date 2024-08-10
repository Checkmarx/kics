resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  acl    = "authenticated-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
