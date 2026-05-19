variable "ssmlogs_s3_bucket" {
  description = "SessionManager log bucket"
  type        = string
  default     = ""
}

resource "aws_s3_bucket_policy" "ssmlogs-s3-bucket" {
  count  = var.ssmlogs_s3_bucket != "" ? 1 : 0
  bucket = aws_s3_bucket.ssmlogs-s3-bucket[0].id
  policy = data.aws_iam_policy_document.ssmlogs-s3-bucket[0].json
}

data "aws_iam_policy_document" "ssmlogs-s3-bucket" {
  count = var.ssmlogs_s3_bucket != "" ? 1 : 0

  statement {
    sid    = "EnforceSSLOnlyRequests"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.ssmlogs-s3-bucket[0].bucket}",
      "arn:aws:s3:::${aws_s3_bucket.ssmlogs-s3-bucket[0].bucket}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
