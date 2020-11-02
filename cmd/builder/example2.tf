//some message in commit
resource "aws_s3_bucket" "b_website" {
  bucket = "my-tf-test-bucket"
  acl = "website"

  values = {
    Name = "My bucket"
    Environment = "Dev"//IncorrectValue:"resource=*,any_key"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "b_website2" {
  bucket = "my-tf-test-bucket"
  acl = "website"

  values = {
    Name = "My bucket"
    Environment = "Dev"//IncorrectValue:"any_key"
  }

  versioning {
    enabled = true
  }
}