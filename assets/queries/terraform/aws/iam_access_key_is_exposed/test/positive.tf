resource "aws_iam_access_key" "positive1" {
  user = "root"
  status = "Active"
}

resource "aws_iam_access_key" "positive2" {
  user = "root"
}
