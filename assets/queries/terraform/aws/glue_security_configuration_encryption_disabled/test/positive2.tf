resource "aws_glue_security_configuration" "positive2" {
  name = "example"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "SSE-KMS"
      kms_key_arn = data.aws_kms_key.example.arn
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "DISABLED"
      kms_key_arn = data.aws_kms_key.example.arn
    }

    s3_encryption {
      kms_key_arn        = data.aws_kms_key.example.arn
      s3_encryption_mode = "SSE-KMS"
    }
  }
}
