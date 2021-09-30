module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket = "my-s3-bucket"
  acl    = "private"

  versioning = {
    enabled = true
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYPOLICYTEST",
  "Statement": [
    {
      "NotAction": "s3:DeleteBucket",
      "Resource": "arn:aws:s3:::*",
      "Sid": "MyStatementId",
      "Effect": "Allow"
    }
  ]
}
POLICY

   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
