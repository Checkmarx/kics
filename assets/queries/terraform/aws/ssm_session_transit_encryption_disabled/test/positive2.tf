resource "aws_ssm_document" "positive2" {
  name          = "test_document"
  document_type = "Session"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Check ip configuration of a Linux instance.",
    "inputs": {
      "s3EncryptionEnabled": true,
      "cloudWatchEncryptionEnabled": true,
      "cloudWatchStreamingEnabled": true,
      "runAsEnabled": false
    }
  }
DOC
}
