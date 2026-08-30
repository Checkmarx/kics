resource "aws_emr_security_configuration" "fail" {
  name = "my-emr-sec-config"
  configuration = jsonencode({
    EncryptionConfiguration = {
      EnableInTransitEncryption = true
      EnableAtRestEncryption    = false
    }
  })
}
