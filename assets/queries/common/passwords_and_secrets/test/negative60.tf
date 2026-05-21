locals {
  rds_password = jsondecode(data.aws_secretsmanager_secret_version.rds_secrets.secret_string)["password"]
}

module "dummydb" {
  source   = "terraform-aws-modules/rds/aws"
  password = local.rds_password
}

module "orchestrator" {
  source                              = "foo"
  services_environment_variables      = local.services_environment_variables
  services_environment_variables_ssm  = local.services_environment_variables_ssm
  services_environment_variables_secret = local.services_environment_variables_secret
}
