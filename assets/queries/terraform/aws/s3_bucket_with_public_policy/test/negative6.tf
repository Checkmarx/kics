# Block Public Access setting at account level
resource "aws_s3_account_public_access_block" "negative6" {

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "negative6" {

  bucket = var.negative6-id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "negative6-0" {
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
      var.negative6-arn,
      "${var.negative6-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "negative6-0" {
  depends_on = [aws_s3_bucket_public_access_block.negative6]
  bucket     = var.negative6-id
  policy     = data.aws_iam_policy_document.negative6-0.json
}
