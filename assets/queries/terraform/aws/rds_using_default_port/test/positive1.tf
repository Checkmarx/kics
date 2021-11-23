resource "aws_db_instance" "positive1" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = aws_elasticache_parameter_group.default.id
  skip_final_snapshot  = true
  port                 = 3306
}
