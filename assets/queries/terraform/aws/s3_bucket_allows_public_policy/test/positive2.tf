#Block Public Access setting at account level missing
resource "aws_s3_account_public_access_block" "negative1" {

  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Block Public Access setting at bucket level exist and is set to false
resource "aws_s3_bucket_public_access_block" "negative1" {

  bucket = var.negative1-id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "negative1-0" {
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
      var.negative1-arn,
      "${var.negative1-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "negative1-0" {
  depends_on = [aws_s3_bucket_public_access_block.negative1]
  bucket     = var.negative1-id
  policy     = data.aws_iam_policy_document.negative1-0.json
}
