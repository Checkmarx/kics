resource "aws_db_instance" "negative1" {
  allocated_storage = 5
  engine            = "postgres"
  instance_class    = "db.t3.small"
  password          = "admin"
  username          = "admin"

  enabled_cloudwatch_logs_exports = ["upgrade"]
}

resource "aws_db_instance" "negative2" {
  allocated_storage = 5
  engine            = "mariadb"
  instance_class    = "db.t3.small"
  password          = "admin"
  username          = "admin"

  enabled_cloudwatch_logs_exports = ["general", "error"]
}
