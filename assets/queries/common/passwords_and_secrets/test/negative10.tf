resource "aws_db_instance" "default" {
  name                   = var.dbname
  engine                 = "mysql"
  option_group_name      = aws_db_option_group.default.name
  parameter_group_name   = aws_db_parameter_group.default.name
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = ["aws_security_group.default.id"]
  identifier              = "rds-${local.resource_prefix.value}"
  engine_version          = "8.0" # Latest major version
  instance_class          = "db.t3.micro"
  allocated_storage       = "20"
  username                = "admin"
  password                = var.password
  apply_immediately       = true
  multi_az                = false
  backup_retention_period = 0
  storage_encrypted       = false
  skip_final_snapshot     = true
  monitoring_interval     = 0
  publicly_accessible     = true
  tags = {
    Name        = "${local.resource_prefix.value}-rds"
    Environment = local.resource_prefix.value
  }

  # Ignore password changes from tf plan diff
  lifecycle {
    ignore_changes = ["password"]
  }
}
