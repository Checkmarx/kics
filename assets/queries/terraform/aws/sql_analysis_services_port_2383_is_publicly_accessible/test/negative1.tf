resource "aws_security_group" "negative1-1" {

  ingress {
    description = "TLS from VPC"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
  }
}

resource "aws_security_group" "negative1-2" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
    cidr_blocks = ["0.1.0.0/0"]
  }
}

resource "aws_security_group" "negative1-3" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 2200
    to_port     = 2500
    protocol    = "tcp"
    ipv6_cidr_blocks = ["2001:db8:abcd:0012::/64"]
  }
}