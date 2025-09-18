# ipv4
resource "aws_security_group" "positive1_ipv4_1" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

resource "aws_security_group" "positive1_ipv4_2" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
}

resource "aws_security_group" "positive1_array_test_ipv4" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "udp"
    cidr_blocks = ["172.16.0.0/12"]
  }
  ingress {
    from_port   = 110
    to_port     = 110
    protocol    = "udp"
    cidr_blocks = ["10.68.0.0", "172.16.0.0/12"]
  }
}

# ipv6

resource "aws_security_group" "positive1_ipv6_1" {
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "-1"
    ipv6_cidr_blocks  = ["fd00::/8"]  # ipv6 equivalent of 10.0.0.0/8
  }
}

resource "aws_security_group" "positive1_ipv6_2" {
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    ipv6_cidr_blocks  = ["fd12:3456:789a::1"]  # private ipv6 address 
  }
}

resource "aws_security_group" "positive1_array_test_ipv6" {
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "udp"
    ipv6_cidr_blocks  = ["fd00:abcd:1234::42"]  # private ipv6 address 
  }

  ingress {
    from_port         = 110
    to_port           = 110
    protocol          = "udp"
    ipv6_cidr_blocks  = ["fd03:5678::/64", "fd00:abcd:1234::42"] 
  }
}