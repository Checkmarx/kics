resource "aws_kms_key" "positive2" {
  description         = "KMS key 2"
  is_enabled          = true
  enable_key_rotation = false
}
