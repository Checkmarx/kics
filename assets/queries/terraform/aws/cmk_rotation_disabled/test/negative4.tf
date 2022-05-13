resource "aws_kms_key" "negative4" {
  description              = "KMS key 4"
  customer_master_key_spec = "RSA_3072"
}
