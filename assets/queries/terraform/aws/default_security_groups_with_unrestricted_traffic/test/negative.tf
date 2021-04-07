resource "aws_default_security_group" "negative1" {
  vpc_id = aws_vpc.mainvpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
    cidr_blocks = ["10.1.0.0/16"]
    ipv6_cidr_blocks = ["250.250.250.1:8451"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"]
    ipv6_cidr_blocks = ["250.250.250.1:8451"]
  }
}