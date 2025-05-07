# test action "*"
resource "aws_s3_bucket_public_access_block" "positive6" {
  count = length(var.positive6)

  bucket = var.positive6[count.index]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive6" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "*",
    ]

    resources = [
      var.positive6,
      "${var.positive6}/*",
    ]
  }
}

#   "Action": "s3:Delete", "Principal":"*" and "Type":"AWS"
resource "aws_s3_bucket_policy" "positive6" {
  depends_on = [aws_s3_bucket_public_access_block.positive6]
  bucket     = var.positive6
  policy     = data.aws_iam_policy_document.positive6.json
}
