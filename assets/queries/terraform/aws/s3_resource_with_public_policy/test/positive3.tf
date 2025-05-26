# Block Public Access setting at bucket level exist and is set to false
resource "aws_s3_bucket_public_access_block" "positive3" {

  bucket = var.positive3-id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive3-0" {
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
      var.positive3-arn,
      "${var.positive3-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "positive3-0" {
  depends_on = [aws_s3_bucket_public_access_block.positive3]
  bucket     = var.positive3-id
  policy     = data.aws_iam_policy_document.positive3-0.json
}
