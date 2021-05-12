resource "aws_rds_cluster" "negative2" {
  cluster_identifier  = "cloudrail-test-non-encrypted"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.03.2"
  engine_mode         = "serverless"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  database_name       = "cloudrail"
  master_username     = "administrator"
  master_password     = "cloudrail-TEST-password"
  skip_final_snapshot = true
}
