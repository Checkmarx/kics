resource "aws_security_group" "negative1-1" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/24", "0.0.0.0/0"]
  }
}

resource "aws_security_group" "negative1-2" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 20
    to_port     = 20
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "negative1-3" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 0
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/24", "192.201.0.0/12"]
  }
}

resource "aws_security_group" "negative1-4" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 0
    to_port     = 10000
    protocol    = "tcp"
    ipv6_cidr_blocks = ["2001:db8:abcd:0012::/64"]
  }
}