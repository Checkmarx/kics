resource "aws_security_group" "positive1-1" {
  name        = "allow_tls"
  description = "SSH port open"

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16", "0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-2" {
  name        = "allow_tls"
  description = "SSH port open"

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16"]
  }

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.121.0.0/16", "0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-3" {
  name        = "allow_tls"
  description = "SSH port open"

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "positive1-4" {
  name        = "allow_tls"
  description = "SSH port open"

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd01::/8"]
  }

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "positive1-5" {
  name        = "allow_tls"
  description = "SSH port open"

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "positive1-6" {
  name        = "allow_tls"
  description = "SSH port open"

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["fd00::/8"]
  }
}

resource "aws_security_group" "positive1-7" {
  name        = "allow_tls"
  description = "SSH port open"

  ingress {
    description = "SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}