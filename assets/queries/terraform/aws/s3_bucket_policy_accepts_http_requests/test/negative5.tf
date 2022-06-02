resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.b.json
}

data "aws_iam_policy_document" "b" {
  statement {
    sid = "ForceSSLOnlyAccess"
    effect = "Deny"
    actions = ["s3:*"]
    resource = [
      aws_s3_bucket.b.arn
    ]
    
    principals {
      type = "*"
      identifiers = ["*"]
    }
    
    contidion {
      test = "Bool"
      values = ["false"]
      variable = "aws:SecureTransport"
    }
  }
}
