#Block Public Access setting at account level
resource "aws_s3_account_public_access_block" "positive5" {

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive5-0" {
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
      var.positive5-arn,
      "${var.positive5-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "positive5-0" {
  depends_on = [aws_s3_bucket_public_access_block.positive5]
  bucket     = var.positive5-id
  policy     = data.aws_iam_policy_document.positive5-0.json
}
