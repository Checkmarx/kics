
data "aws_iam_policy_document" "pos4" {

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
      "arn:aws:s3:::a/*",
      "arn:aws:s3:::a",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}


resource "aws_s3_bucket" "pos4" {
  bucket = "a"
  policy = data.aws_iam_policy_document.pos4.json
}
