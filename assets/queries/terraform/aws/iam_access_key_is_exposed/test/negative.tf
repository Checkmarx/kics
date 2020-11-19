resource "aws_iam_access_key" "root-example-1" {
  user = "root"
}

resource "aws_iam_access_key" "root-example-2" {
  user = "root"
  status = "Active"
}

resource "aws_iam_access_key" "user-example" {
  user = "some-user"
  status = "Inactive"
}
