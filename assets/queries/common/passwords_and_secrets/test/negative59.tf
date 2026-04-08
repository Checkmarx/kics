resource "aws_secretsmanager_secret_version" "secret_version" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password.client_password[each.key].result })
}

resource "aws_secretsmanager_secret_version" "secret_version_2" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password[each.key].client_password.result })
}

resource "aws_secretsmanager_secret_version" "secret_version_3" {
  for_each = { for k, v in var.clients.scram : k => v if var.enabled && var.client_sasl_scram_enabled }

  secret_id     = aws_secretsmanager_secret.client_secret[each.key].id                                                                                              # use of indexes
  secret_string = jsonencode({ "username" : join("_", [var.product, each.key, var.environment == "dev" ? var.environment : var.stack]), "password" : random_password["index"].client_password.result })
}

resource "aws_msk_scram_secret_association" "msk_secret_association" {
  count           = var.enabled && var.client_sasl_scram_enabled ? 1 : 0
  cluster_arn     = aws_msk_cluster.kafka[0].arn
  secret_arn_list = [for secret in aws_secretsmanager_secret.client_secret : secret.arn] # short reference
}

resource "aws_msk_scram_secret_association" "msk_secret_association_2" {
  count           = var.enabled && var.client_sasl_scram_enabled ? 1 : 0
  cluster_arn     = aws_msk_cluster.kafka[0].arn
  secret_arn_list = [for secret in aws_secretsmanager_secret.client_secret : null] # short reference
}
