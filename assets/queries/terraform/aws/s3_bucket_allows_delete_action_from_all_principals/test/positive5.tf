# test action "s3:*"
resource "aws_s3_bucket_public_access_block" "positive5" {
  count = length(var.positive5)

  bucket = var.positive5[count.index]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive5" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [
      var.positive5,
      "${var.positive5}/*",
    ]
  }
}

#   "Action": "s3:Delete", "Principal":"*" and "Type":"AWS"
resource "aws_s3_bucket_policy" "positive5" {
  depends_on = [aws_s3_bucket_public_access_block.positive5]
  bucket     = var.positive5
  policy     = data.aws_iam_policy_document.positive5.json
}
