resource "aws_kms_key" "a2" {
  description             = "KMS key 1"
  is_enabled = true
  enable_key_rotation = false
}
