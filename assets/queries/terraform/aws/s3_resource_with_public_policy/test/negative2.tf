#Block Public Access setting at account level
resource "aws_s3_account_public_access_block" "negative2" {

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "negative2-0" {
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
      var.negative2-arn,
      "${var.negative2-arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "negative2-0" {
  depends_on = [aws_s3_bucket_public_access_block.negative2]
  bucket     = var.negative2-id
  policy     = data.aws_iam_policy_document.negative2-0.json
}
