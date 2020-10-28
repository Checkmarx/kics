//some message in commit
resource "aws_s3_bucket" "b_website" {
  bucket = "my-tf-test-bucket" //RedundantAttribute
  acl = "website" //IncorrectValue, expected "private"

  //IncorrectValue, RedundantAttribute
  tags = {
    Name = "My bucket"
    Environment = "Dev" //IncorrectValue
  }

  versioning {
    enabled = true //MissingAttribute, IncorrectValue, expected "false"
  }
}

resource "aws_iam_access_key" "user" {
  name = "${local.resource_prefix.value}-user"
  user = aws_iam_user.user.name //IncorrectValue, expected "test"
}
