variable "kms" {
  type = string
}

resource "aws_ssm_document" "negative3" {
  name          = "test_document"
  document_type = "Session"

  content = jsonencode({
    schemaVersion = "1.0"
    inputs = {
      kmsKeyId = var.kms
    }
  })
}
