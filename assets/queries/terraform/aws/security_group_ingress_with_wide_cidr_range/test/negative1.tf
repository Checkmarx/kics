resource "aws_security_group" "negative1" {
  name = "negative1"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_security_group" "negative2" {
  name = "negative2"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/24"]
  }
}

# 10.0.0.0/8 is the standard RFC 1918 Class-A private range — excluded
resource "aws_security_group" "negative3" {
  name = "negative3"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

# 0.0.0.0/0 is already detected by unrestricted_security_group_ingress
resource "aws_security_group" "negative4" {
  name = "negative4"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "negative5" {
  security_group_id = aws_security_group.negative1.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
