variable "config" {
  type    = any
  default = null
}

resource "aws_ssm_document" "positive5" {
  name          = "test_document"
  document_type = "Session"

  content = jsonencode({
    description = var.config.description
    inputs = { "kmsKeyId" = null }
  })
}
