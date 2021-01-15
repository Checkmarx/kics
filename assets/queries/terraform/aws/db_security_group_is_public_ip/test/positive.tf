resource "aws_db_security_group" "default" {
  name = "rds_sg"

  ingress {
    cidr = "192.168.1.111/2"
  }
}