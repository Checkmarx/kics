variable "prefs" {
  type = object({
    kms = optional(string, "")
  })
  default = null
}

resource "aws_ssm_document" "negative4" {
  name          = "test_document"
  document_type = "Session"

  content = jsonencode({
    schemaVersion = "1.0"
    inputs = {
      kmsKeyId = var.prefs.kms
    }
  })
}
