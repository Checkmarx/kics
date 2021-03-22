resource "aws_iam_access_key" "negative1" {
  user = "root"
}

resource "aws_iam_access_key" "negative2" {
  user = "root"
  status = "Active"
}

resource "aws_iam_access_key" "negative3" {
  user = "some-user"
  status = "Inactive"
}
