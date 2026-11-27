# 7277: a local reference is not a hardcoded password
module "orchestrator" {
  source = "foo"

  services_environment_variables        = local.services_environment_variables
  services_environment_variables_secret = local.services_environment_variables_secret
  services_environment_variables_ssm    = local.services_environment_variables_ssm
}

resource "aws_db_instance" "dummydb" {
  identifier = "testdb"
  engine     = "postgres"
  username   = "testuser"
  password   = local.dummydb_password
}
