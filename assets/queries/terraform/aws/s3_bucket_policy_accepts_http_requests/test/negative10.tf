data "aws_iam_policy_document" "neg10" {
  for_each = toset(["primary", "replica"])

  statement {
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::neg10/*",
      "arn:aws:s3:::neg10",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket" "neg10" {
  bucket = "neg10"
  policy = data.aws_iam_policy_document.neg10["primary"].json
}
