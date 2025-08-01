data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "read"
    ]
    resources = [
      "*",
    ]
  }
}
