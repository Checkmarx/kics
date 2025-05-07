# Block Public Access setting at account level
resource "aws_s3_account_public_access_block" "positive6" {

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "positive6" {

  bucket = var.positive6-id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive6-0" {
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
      var.positive6-arn,
      "${var.positive6-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "positive6-0" {
  depends_on = [aws_s3_bucket_public_access_block.positive6]
  bucket     = var.positive6-id
  policy     = data.aws_iam_policy_document.positive6-0.json
}
