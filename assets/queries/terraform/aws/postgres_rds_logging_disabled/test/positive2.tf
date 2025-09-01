resource "aws_db_parameter_group" "postgres_logging" {
  name   = "postgres-logging"
  family = "postgres14"
  parameter {
    name  = "log_statement"
    value = "not_all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1"
  }
}
