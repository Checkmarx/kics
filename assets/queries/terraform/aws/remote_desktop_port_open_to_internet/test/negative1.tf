resource "aws_security_group" "negative1-1" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 3380
    to_port     = 3450
    protocol    = "tcp"
  }
}

resource "aws_security_group" "negative1-2" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 3380
    to_port     = 3450
    protocol    = "tcp"
    cidr_blocks = ["0.1.0.0/0"]
  }
}

resource "aws_security_group" "negative1-3" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 3380
    to_port     = 3450
    protocol    = "tcp"
    ipv6_cidr_blocks = ["2001:db8:abcd:0012::/64"]
  }
}

resource "aws_security_group" "negative1-4" {
  name        = "allow_tls"
  description = "sample"

  ingress {
    description = "sample"
    from_port   = 2000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "sample"
    from_port   = 2000
    to_port     = 3000
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "negative1-5" {
  name        = "allow_tls"
  description = "sample"

  ingress {
    description = "sample"
    from_port   = 3380
    to_port     = 3450
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "sample"
    from_port   = 3380
    to_port     = 3450
    protocol    = "udp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}