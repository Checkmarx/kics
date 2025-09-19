resource "aws_security_group" "positive1-1" {
  name        = "allow_tls"
  description = "Unknown port exposed"

  ingress {
    description = "Unknown port exposed"
    from_port   = 44
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-2" {
  name        = "allow_tls"
  description = "Unknown port exposed"

  ingress {
    description = "Unknown port exposed"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/24", "0.0.0.0/0"]
  }

  ingress {
    description = "Unknown port exposed"
    from_port   = 18
    to_port     = 18
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/24", "0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-3" {
  name        = "allow_tls"
  description = "Unknown port exposed"

  ingress {
    description = "Remote desktop open private"
    from_port   = 600
    to_port     = 1200
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "positive1-4" {
  name        = "allow_tls"
  description = "Unknown port exposed"

  ingress {
    description = "Unknown port exposed"
    from_port   = 60
    to_port     = 85
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd01::/8"]
  }

  ingress {
    description = "Unknown port exposed"
    from_port   = 65
    to_port     = 81
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "positive1-5" {
  name        = "allow_tls"
  description = "Unknown port exposed"

  ingress {
    description = "Unknown port exposed"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "positive1-6" {
  name        = "allow_tls"
  description = "Unknown port exposed"

  ingress {
    description = "Unknown port exposed"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["fd00::/8"]
  }
}

resource "aws_security_group" "positive1-7" {
  name        = "allow_tls"
  description = "Unknown port exposed"

  ingress {
    description = "Unknown port exposed"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}