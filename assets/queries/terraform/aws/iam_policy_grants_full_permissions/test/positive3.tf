resource "aws_s3_bucket_public_access_block" "example" {
  count = length(var.example-arn)

  bucket = var.example-id[count.index]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "example-0" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "*",
    ]

    resources = [
      var.example-arn[0],
      "${var.example-arn[0]}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "example-0" {
  depends_on = [aws_s3_bucket_public_access_block.example]
  bucket     = var.example-id[0]
  policy     = data.aws_iam_policy_document.example-0.json
}

data "aws_iam_policy_document" "example-1" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [
      var.example-arn[1],
      "${var.example-arn[1]}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "example-1" {
  depends_on = [aws_s3_bucket_public_access_block.example]
  bucket     = var.example-id[1]
  policy     = data.aws_iam_policy_document.example-1.json
}

data "aws_iam_policy_document" "example-2" {
  statement {
    principals {
      type        = "AWS"
      #identifiers = ["*"]
      identifiers = ["arn:aws:iam::123456789012:role/backup-role"]
    }

    effect = "Allow"

    actions = [
      "s3:Delete*",
    ]

    resources = [
      var.example-arn[2],
      "${var.example-arn[2]}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "example-2" {
  depends_on = [aws_s3_bucket_public_access_block.example]
  bucket     = var.example-id[2]
  policy     = data.aws_iam_policy_document.example-2.json
}
