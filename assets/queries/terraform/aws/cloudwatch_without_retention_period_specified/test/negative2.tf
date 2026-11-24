variable "cloudwatch_log_retention_period" {
  description = "Cloudwatch log retention period in days"
  type        = map(string)
  default = {
    feature    = 1
    dev        = 5
    test       = 5
    stage      = 30
    production = 90
  }
}

locals {
  environment = "dev"
}

resource "aws_cloudwatch_log_group" "negative2" {
  name = "Yada"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }

  retention_in_days = var.cloudwatch_log_retention_period[local.environment]
}
