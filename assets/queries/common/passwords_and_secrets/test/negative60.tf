# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding TF resource access"                   allow-rule-test - #1
# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding array access"                         allow-rule-test - #2
# "Generic Secret"   - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding TF resource access"                   allow-rule-test - #3
# "Generic Secret"   - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99 - "Avoiding Secrets from Variable Interpolation"  allow-rule-test - #4

resource "aws_secretsmanager_secret_version" "secret_version" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  #1:
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password.client_password[each.key].result })
}

resource "aws_secretsmanager_secret_version" "secret_version_2" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  #1:
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password[each.key].client_password.result })
}

resource "aws_secretsmanager_secret_version" "secret_version_3" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  #2:
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password["index"].client_password.result })
}

resource "aws_msk_scram_secret_association" "msk_secret_association" {
  count           = var.enabled && var.client_sasl_scram_enabled ? 1 : 0
  cluster_arn     = aws_msk_cluster.kafka[0].arn
  secret_arn_list = [for secret in aws_secretsmanager_secret.client_secret : secret.arn]     #3
}

resource "aws_msk_scram_secret_association" "msk_secret_association_2" {
  count           = var.enabled && var.client_sasl_scram_enabled ? 1 : 0
  cluster_arn     = aws_msk_cluster.kafka[0].arn
  secret_arn_list = [for secret in aws_secretsmanager_secret.client_secret : "${secret.arn}"] #4
}