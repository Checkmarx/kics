resource "aws_db_instance" "positive4" {
  allocated_storage    = 10
  engine               = "sqlserver-ee"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  skip_final_snapshot  = true
  port                 = 1433
}
