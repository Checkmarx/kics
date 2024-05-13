resource "aws_s3_bucket" "negative1" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }
}


resource "aws_athena_database" "hoge" {
  name   = "database_name"
  bucket = aws_s3_bucket.hoge.bucket
}
