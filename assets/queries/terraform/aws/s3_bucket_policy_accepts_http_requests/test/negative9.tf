data "aws_iam_policy_document" "neg9" {
  count = 1

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
      "arn:aws:s3:::neg9/*",
      "arn:aws:s3:::neg9",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket" "neg9" {
  bucket = "neg9"
  policy = data.aws_iam_policy_document.neg9[0].json
}
