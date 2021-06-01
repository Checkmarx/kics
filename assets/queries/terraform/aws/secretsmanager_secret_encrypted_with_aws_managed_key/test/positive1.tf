resource "aws_secretsmanager_secret" "test2" {
  name       = "test-cloudrail-1"
  kms_key_id = "alias/aws/secretsmanager"
}
