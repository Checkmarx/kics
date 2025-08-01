
data "aws_iam_policy_document" "example" {
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

  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [
      "*",
    ]
  }

  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "iam:*"
    ]
    resources = [
      "*",
    ]
  }
}
