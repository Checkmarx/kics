#Block Public Access setting at account level
resource "aws_s3_account_public_access_block" "positive4" {

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Block Public Access setting at bucket level
resource "aws_s3_bucket_public_access_block" "positive4" {

  bucket = var.positive4-id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "positive4-0" {
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
      var.positive4-arn,
      "${var.positive4-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "positive4-0" {
  depends_on = [aws_s3_bucket_public_access_block.positive4]
  bucket     = var.positive4-id
  policy     = data.aws_iam_policy_document.positive4-0.json
}
