resource "aws_security_group" "ec2" {
  name        = "Dont open remote desktop port"
  description = "Doesn't enable the remote desktop port"
}

resource "aws_security_group" "negative1-1" {
  ingress {
    description = "Remote desktop open private"
    from_port   = 18
    to_port     = 30
    protocol    = "tcp"
  }
}

resource "aws_security_group" "negative1-2" {

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16", "75.132.0.0/16"]
  }
}

resource "aws_security_group" "negative1-3" {

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "fd01::/8"]
  }
}