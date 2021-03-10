resource "aws_kms_key" "positive1" {
  description             = "KMS key 1"
  
  is_enabled = true

  enable_key_rotation = true

}


resource "aws_kms_key" "positive2" {
  description             = "KMS key 1"
  
  is_enabled = true

  enable_key_rotation = true

  deletion_window_in_days = 31
}
