# "Encryption Key"  - 9fb1cd65-7a07-4531-9bcf-47589d0f82d6 - "Avoiding TF resource access"  allow-rule-test - #1
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

variable "encryption_key" {
  description = "Encryption key from external config"
  type        = string
  sensitive   = true
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

  encryption_key = aws_kms_key.client_encryption_key[each.key].arn  #1
}

module "storage_2" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }
  source   = "./modules/storage"

  encryption_key = aws_kms_key[each.key].client_encryption_key.arn  #1
}

module "storage_3" {
  for_each = { for k, v in var.clients.storage : k => v if var.enabled }
  source   = "./modules/storage"

  encryption_key = aws_kms_key["index"].client_encryption_key.arn   #3
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_enc" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.main[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = [for k in aws_kms_key.client_encryption_key : k.arn]  #1
    }
  }
}

module "optional_encryption" {
  source = "./modules/storage"

  encryption_key = null #1
}

module "database" {
  source = "./modules/database"

  encryption_key = var.encryption_key #2
}

module "app" {
  source = "./modules/app"

  encryption_key = module.encryption.key_output.value #1
}

data "aws_kms_key" "existing" {
  key_id = "alias/existing-encryption-key"
}

module "legacy" {
  source = "./modules/legacy"

  encryption_key = data.aws_kms_key.existing.arn  #1
}

locals {
  encryption_config = {
    key_arn = aws_kms_key.client_encryption_key["primary"].arn
  }
}

module "monitoring" {
  source = "./modules/monitoring"

  encryption_key = local.encryption_config.key_arn  #1
}