resource "aws_db_instance" "positive1" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  iam_database_authentication_enabled = false
}
