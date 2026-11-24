variable "config" {
  type    = any
  default = null
}

resource "aws_ssm_document" "positive4" {
  name          = "test_document"
  document_type = "Session"

  content = jsonencode({
    kmsKeyId = var.config.kms
    inputs = {}
  })
}
