resource "aws_kms_key" "positive3" {
  description              = "KMS key 3"
  is_enabled               = true
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = false
}
