resource "aws_iam_user" "example" {
  name          = "example"
  path          = "/"
  force_destroy = true
}
