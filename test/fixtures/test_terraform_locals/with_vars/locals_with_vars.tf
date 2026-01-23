variable "environment" {
  type    = string
  default = "production"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

locals {
  resource_prefix = "${var.environment}-${var.region}"
  tag_name        = var.environment
}

resource "terraform_data" "with_vars" {
  prefix = local.resource_prefix
  tag    = local.tag_name
}

