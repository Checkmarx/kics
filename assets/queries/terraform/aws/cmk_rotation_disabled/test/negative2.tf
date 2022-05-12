resource "aws_kms_key" "negative2" {
  description              = "KMS key 2"
  customer_master_key_spec = "RSA_4096"
}
