resource "aws_db_instance" "positive3" {
  allocated_storage    = 10
  engine               = "oracle-ee"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  skip_final_snapshot  = true
  port                 = 1521
}
