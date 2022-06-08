
data "aws_iam_policy_document" "neg6" {

  statement {
    effect = "Allow"

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


resource "aws_s3_bucket" "neg6" {
  bucket = "a"
  policy = data.aws_iam_policy_document.neg6.json
}
