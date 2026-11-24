variable "config" {
  type    = any
  default = null
}

resource "aws_ssm_document" "positive6" {
  name          = "test_document"
  document_type = "Session"

  content = jsonencode({
    inputs = { nested = { kmsKeyId = var.config.kms } }
  })
}
