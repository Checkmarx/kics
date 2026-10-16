resource "aws_db_instance" "fail" {
  identifier        = "mydb"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  multi_az          = false
}
