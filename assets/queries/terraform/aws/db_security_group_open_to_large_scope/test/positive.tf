resource "aws_db_security_group" "positive1" {
  name = "rds_sg"

  ingress {
    cidr = "10.0.0.0/24"
  }
}