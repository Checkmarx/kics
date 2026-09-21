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
    description = "sample"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
    cidr_blocks = ["0.1.0.0/0"]
  }
}

resource "aws_security_group" "negative1-3" {

  ingress {
    description = "sample"
    from_port   = 2200
    to_port     = 2500
    protocol    = "tcp"
    ipv6_cidr_blocks = ["2001:db8:abcd:0012::/64"]
  }
}

resource "aws_security_group" "negative1-4" {
  name        = "allow_tls"
  description = "sample"

  ingress {
    description = "sample"
    from_port   = 20
    to_port     = 2000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "sample"
    from_port   = 20
    to_port     = 2000
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "negative1-5" {
  name        = "allow_tls"
  description = "sample"

  ingress {
    description = "sample"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16"]
    ipv6_cidr_blocks = ["fd00::/8"]
  }
}

resource "aws_security_group" "negative1-6" {
  name        = "allow_tls"
  description = "sample"

  ingress {
    description = "sample"
    from_port   = 2383
    to_port     = 2383
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "sample"
    from_port   = 2383
    to_port     = 2383
    protocol    = "udp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}