resource "aws_security_group" "positive1-ipv4" {
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.default.id
  }
}

resource "aws_security_group" "positive1-ipv6" {
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.default.id
  }
}

resource "aws_security_group" "positive1-ipv4_array" {
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["1.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-ipv6_array" {
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    ipv6_cidr_blocks  = ["fc00::/8"]
  }

  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    ipv6_cidr_blocks  = ["::/0"]
  }
}