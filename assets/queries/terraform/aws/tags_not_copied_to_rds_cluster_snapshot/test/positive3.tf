resource "aws_db_instance" "example" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  identifier             = "my-rds-instance"
  username               = "admin"
  password               = "YourSecretPassword"
  skip_final_snapshot    = true

  copy_tags_to_snapshot  = false
}
