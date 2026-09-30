# "Generic Token"   - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding TF resource access"  allow-rule-test - #1
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables"        allow-rule-test - #2
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding array access"        allow-rule-test - #3
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "auth_token" {
  description = "Authentication token"
  type        = string
  sensitive   = true
}

variable "enabled" {
  description = "Whether to enable resources"
  type        = bool
  default     = true
}

resource "aws_secretsmanager_secret_version" "token_version" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id
  secret_string = jsonencode({ "client" : each.key, "token" : random_password.client_token[each.key].result })  #1
}

resource "aws_secretsmanager_secret_version" "token_version_2" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id
  secret_string = jsonencode({ "client" : each.key, "token" : random_password[each.key].client_token.result }) #1
}

resource "aws_secretsmanager_secret_version" "token_version_3" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id                                   #3
  secret_string = jsonencode({ "client" : each.key, "token" : random_password["index"].client_token.result })
}

resource "aws_lb_listener" "https_null" {
  count             = var.enabled ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type      = "fixed-response"
    token_key = null  #1
  }
}
module "auth_service" {
  source = "./modules/auth"

  token = var.auth_token  #2
}
module "api_gateway" {
  source = "./modules/gateway"

  token = module.auth_service.token_output.value  #1
}
module "legacy_service" {
  source = "./modules/legacy"

  token = data.aws_secretsmanager_secret_version.existing_token.secret_string  #1
}

locals {
  token_config = {
    value = aws_secretsmanager_secret.client_token_secret["primary"].arn
  }
}

module "monitoring" {
  source = "./modules/monitoring"

  token = local.token_config.value  #1
}