resource "aws_kms_key" "positive3" {
  description              = "KMS key 4"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = false
}
