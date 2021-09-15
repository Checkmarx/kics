resource "aws_glue_data_catalog_encryption_settings" "positive2" {
  data_catalog_encryption_settings {
    connection_password_encryption {
      return_connection_password_encrypted = true
    }

    encryption_at_rest {
      catalog_encryption_mode = "SSE-KMS"
      sse_aws_kms_key_id      = aws_kms_key.test.arn
    }
  }
}
