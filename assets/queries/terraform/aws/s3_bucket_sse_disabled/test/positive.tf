resource "aws_s3_bucket" "positive1" {
  bucket = "mybucket"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "some-key"
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "positive2" {
  bucket = "mybucket"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
      }
    }
  }
}


