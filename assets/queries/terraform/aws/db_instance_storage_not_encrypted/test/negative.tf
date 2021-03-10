resource "aws_db_instance" "negative1" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  iam_database_authentication_enabled = true
  storage_encrypted = true
}

resource "aws_db_instance" "negative2" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  iam_database_authentication_enabled = false
  kms_key_id = aws_kms_key.my_key.key_id
}
