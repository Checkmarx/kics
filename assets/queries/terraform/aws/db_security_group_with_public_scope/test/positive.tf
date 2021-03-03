resource "aws_db_security_group" "default" {
  name = "rds_sg"

  ingress {
    cidr = "0.0.0.0/0"
  }
}