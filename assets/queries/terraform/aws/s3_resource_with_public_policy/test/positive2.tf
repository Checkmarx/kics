# Block Public Access setting at bucket level missing
resource "aws_s3_bucket_public_access_block" "positive2" {

  bucket = var.positive2-id

  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive2-0" {
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
      var.positive2-arn,
      "${var.positive2-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "positive2-0" {
  depends_on = [aws_s3_bucket_public_access_block.positive2]
  bucket     = var.positive2-id
  policy     = data.aws_iam_policy_document.positive2-0.json
}
