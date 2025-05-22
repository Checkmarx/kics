#Block Public Access setting at bucket level
resource "aws_s3_bucket_public_access_block" "positive1" {

  bucket = var.positive1-id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive1-0" {
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
      var.positive1-arn,
      "${var.positive1-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "positive1-0" {
  depends_on = [aws_s3_bucket_public_access_block.positive1]
  bucket     = var.positive1-id
  policy     = data.aws_iam_policy_document.positive1-0.json
}
