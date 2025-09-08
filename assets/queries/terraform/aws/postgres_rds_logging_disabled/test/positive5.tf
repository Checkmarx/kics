resource "aws_db_parameter_group" "example" {
  name   = "postgres-logging"
  family = "postgres14"
  
  parameter {
    name = "log_statement"
    value = "all"
  }
}