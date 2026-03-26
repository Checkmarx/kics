# Sample to test 'Generic Token' - allow TF resource access rule
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

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "enabled" {
  description = "Whether to enable resources"
  type        = bool
  default     = true
}

variable "clients" {
  description = "Client configurations"
  type = object({
    oauth = map(object({
      enabled = bool
    }))
  })
}

resource "aws_secretsmanager_secret_version" "token_version" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id
  secret_string = jsonencode({ "client" : each.key, "token" : random_password.client_token[each.key].result })
}

resource "aws_secretsmanager_secret_version" "token_version_2" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id
  secret_string = jsonencode({ "client" : each.key, "token" : random_password[each.key].client_token.result })
}

resource "aws_secretsmanager_secret_version" "token_version_3" {
  for_each = { for k, v in var.clients.oauth : k => v if var.enabled }

  secret_id     = aws_secretsmanager_secret.client_token_secret[each.key].id
  secret_string = jsonencode({ "client" : each.key, "token" : random_password["index"].client_token.result })
}

resource "aws_lb_listener" "https" {
  count             = var.enabled ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = [for t in aws_lb_target_group.app : t.token_key]
  }
}

resource "aws_lb_listener" "https_null" {
  count             = var.enabled ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type      = "fixed-response"
    token_key = null
  }
}
module "auth_service" {
  source = "./modules/auth"

  token = var.auth_token
}
module "api_gateway" {
  source = "./modules/gateway"

  token = module.auth_service.token_output.value
}
module "legacy_service" {
  source = "./modules/legacy"

  token = data.aws_secretsmanager_secret_version.existing_token.secret_string
}

locals {
  token_config = {
    value = aws_secretsmanager_secret.client_token_secret["primary"].arn
  }
}

module "monitoring" {
  source = "./modules/monitoring"

  token = local.token_config.value
}