resource "aws_db_parameter_group" "postgres_logging" {
  name   = "postgres-logging"
  family = "postgres14"
}
