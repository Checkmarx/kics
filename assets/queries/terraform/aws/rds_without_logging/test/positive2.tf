resource "aws_db_instance" "positive2" {
  allocated_storage = 5
  engine            = "postgres"
  instance_class    = "db.t3.small"
  password          = "admin"
  username          = "admin"
  enabled_cloudwatch_logs_exports = []
}
