resource "aws_kms_key" "positive5" {
  description              = "KMS key 5"
  customer_master_key_spec = "RSA_2048"
  enable_key_rotation      = true
}
