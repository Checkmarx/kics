# test action "s3:Delete*"
resource "aws_s3_bucket_public_access_block" "positive4" {
  count = length(var.positive4)

  bucket = var.positive4[count.index]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive4" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:Delete*",
    ]

    resources = [
      var.positive4,
      "${var.positive4}/*",
    ]
  }
}

#   "Action": "s3:Delete", "Principal":"*" and "Type":"AWS"
resource "aws_s3_bucket_policy" "positive4" {
  depends_on = [aws_s3_bucket_public_access_block.positive4]
  bucket     = var.positive4
  policy     = data.aws_iam_policy_document.positive4.json
}
