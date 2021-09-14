resource "aws_ssm_document" "negative" {
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
      "runAsEnabled": false,
      "kmsKeyId": "${var.kms_key_id}"
    }
  }
DOC
}
