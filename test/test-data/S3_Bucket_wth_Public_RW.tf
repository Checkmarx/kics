//comment to offset
resource "aws_s3_bucket" "b_website" {
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

//comment to offset
resource "aws_s3_bucket" "b_public_read" {
  bucket = "my-tf-test-bucket"
  acl    = "public-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }
}

//comment to offset
resource "aws_s3_bucket" "b_public_read_write" {
  bucket = "my-tf-test-bucket"
  acl    = "public-read-write"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }
}
