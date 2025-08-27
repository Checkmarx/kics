resource "aws_backup_vault" "example" {
  name        = "example_backup_vault"
  kms_key_arn = aws_kms_key.example.arn
}