# Block Public Access setting at bucket level
resource "aws_s3_bucket_public_access_block" "positive4" {

  bucket = var.positive4-id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "negative4-0" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      var.negative4-arn,
      "${var.negative4-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "negative4-0" {
  depends_on = [aws_s3_bucket_public_access_block.negative4]
  bucket     = var.negative4-id
  policy     = data.aws_iam_policy_document.negative4-0.json
}
