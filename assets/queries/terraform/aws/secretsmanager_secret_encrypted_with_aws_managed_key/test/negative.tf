resource "aws_secretsmanager_secret" "test222" {
  name       = "test-cloudrail-1"
  kms_key_id = "alias/MyAlias"
}

