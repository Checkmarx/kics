resource "aws_iam_access_key" "negative1" {
  user = "some-user"
}

resource "aws_iam_access_key" "negative2" {
  user = "some-user"
  status = "Active"
}

resource "aws_iam_access_key" "negative3" {
  user = "root"
  status = "Inactive"
}
