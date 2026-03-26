# Sample for 'Encryption Key' - avoiding TF resource access rule
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

variable "encryption_key" {
  description = "Encryption key from external config"
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
    storage = map(object({
      enabled = bool
    }))
  })
}

resource "aws_kms_key" "client_encryption_key" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }

  description             = "KMS key for ${each.key}"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "client_encryption_alias" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }

  name          = "alias/${each.key}-encryption"
  target_key_id = aws_kms_key.client_encryption_key[each.key].key_id
}

module "storage" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }
  source   = "./modules/storage"

  encryption_key = aws_kms_key.client_encryption_key[each.key].arn
}

module "storage_2" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }
  source   = "./modules/storage"

  encryption_key = aws_kms_key[each.key].client_encryption_key.arn
}

module "storage_3" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }
  source   = "./modules/storage"

  encryption_key = aws_kms_key["index"].client_encryption_key.arn
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_enc" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.main[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      encryption_key = [for k in aws_kms_key.client_encryption_key : k.arn]
    }
  }
}

module "optional_encryption" {
  source = "./modules/storage"

  encryption_key = null
}

module "database" {
  source = "./modules/database"

  encryption_key = var.encryption_key
}

module "encryption" {
  source = "./modules/encryption"

  environment = var.environment
}

module "app" {
  source = "./modules/app"

  encryption_key = module.encryption.key_output.value
}

data "aws_kms_key" "existing" {
  key_id = "alias/existing-encryption-key"
}

module "legacy" {
  source = "./modules/legacy"

  encryption_key = data.aws_kms_key.existing.arn
}

locals {
  encryption_config = {
    key_arn = aws_kms_key.client_encryption_key["primary"].arn
  }
}

module "monitoring" {
  source = "./modules/monitoring"

  encryption_key = local.encryption_config.key_arn
}