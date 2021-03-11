resource "aws_db_security_group" "positive1" {
  name = "rds_sg"

  ingress {
    cidr = "192.168.1.111/2"
  }
}