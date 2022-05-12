resource "aws_kms_key" "negative4" {
  description              = "KMS key 3"
  customer_master_key_spec = "RSA_3072"
}
