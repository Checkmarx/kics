resource "aws_kms_key" "a" {
  description             = "KMS key 1"
  
  is_enabled = true

  enable_key_rotation = true

}




resource "aws_kms_key" "a2" {
  description             = "KMS key 1"
  
  is_enabled = true

  enable_key_rotation = true

  deletion_window_in_days = 6
}


resource "aws_kms_key" "a3" {
  description             = "KMS key 1"
  
  is_enabled = true

  enable_key_rotation = true

  deletion_window_in_days = 31
}
