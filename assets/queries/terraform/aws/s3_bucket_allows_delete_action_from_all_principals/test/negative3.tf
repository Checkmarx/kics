# test principal type not AWS
resource "aws_s3_bucket_public_access_block" "negative3" {
  count = length(var.negative3)

  bucket = var.negative3[count.index]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "negative3" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:Delete*",
    ]

    resources = [
      var.negative3,
      "${var.negative3}/*",
    ]
  }
}

#   "Action": "s3:Delete", "Principal":"*" and "Type":"Service"
resource "aws_s3_bucket_policy" "negative3" {
  depends_on = [aws_s3_bucket_public_access_block.negative3]
  bucket     = var.negative3
  policy     = data.aws_iam_policy_document.negative3.json
}
