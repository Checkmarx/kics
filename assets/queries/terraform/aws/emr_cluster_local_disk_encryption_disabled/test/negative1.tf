resource "aws_emr_security_configuration" "pass" {
  name = "my-emr-sec-config"
  configuration = jsonencode({
    EncryptionConfiguration = {
      EnableInTransitEncryption = true
      EnableAtRestEncryption    = true
      AtRestEncryptionConfiguration = {
        LocalDiskEncryptionConfiguration = {
          EncryptionKeyProviderType = "AwsKms"
          AwsKmsKey                 = "arn:aws:kms:us-east-1:123456789012:key/example"
        }
      }
    }
  })
}
