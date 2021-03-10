resource "aws_kms_key" "negative1" {
  description             = "KMS key 1"
  
  is_enabled = true

  enable_key_rotation = true

  deletion_window_in_days = 10
}