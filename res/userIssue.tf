resource "aws_s3_bucket_policy" "https_common" {
  bucket = aws_s3_bucket.common.id
  policy = data.aws_iam_policy_document.common_policy.json
}

data "aws_iam_policy_document" "common_policy" {
  statement {
    sid    = "https"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.common.arn,
      "${aws_s3_bucket.common.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "common" {
  bucket = "hoge"
  arn = "abc"
}
