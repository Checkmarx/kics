resource "aws_backup_vault" "negative1" {
  name        = "example_vault"
  kms_key_arn = aws_kms_key.example.arn
}
