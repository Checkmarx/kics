resource "aws_iam_access_key" "user-active" {
  user = "some-user"
  status = "Active"
}

resource "aws_iam_access_key" "user-default" {
  user = "some-user"
}