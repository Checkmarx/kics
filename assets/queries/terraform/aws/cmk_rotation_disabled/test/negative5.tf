resource "aws_kms_key" "negative5" {
  description              = "KMS key 5"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
}
