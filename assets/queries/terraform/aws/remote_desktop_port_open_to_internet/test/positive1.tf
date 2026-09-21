resource "aws_security_group" "positive1-1" {
  name        = "allow_tls"
  description = "Remote desktop port open"

  ingress {
    description = "Remote desktop port open"
    from_port   = 3380
    to_port     = 3450
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-2" {
  name        = "allow_tls"
  description = "Remote desktop port open"

  ingress {
    description = "Remote desktop port open"
    from_port   = 3381
    to_port     = 3445
    protocol    = "tcp"
    cidr_blocks = ["1.0.0.0/0"]
  }

  ingress {
    description = "Remote desktop port open"
    from_port   = 3000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-3" {
  name        = "allow_tls"
  description = "Remote desktop port open"

  ingress {
    description = "Remote desktop port open"
    from_port   = 3380
    to_port     = 3450
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "positive1-4" {
  name        = "allow_tls"
  description = "Remote desktop port open"

  ingress {
    description = "Remote desktop port open"
    from_port   = 3381
    to_port     = 3445
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd01::/8"]
  }

  ingress {
    description = "Remote desktop port open"
    from_port   = 3000
    to_port     = 4000
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "positive1-5" {
  name        = "allow_tls"
  description = "Remote desktop port open"

  ingress {
    description = "Remote desktop port open"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "positive1-6" {
  name        = "allow_tls"
  description = "Remote desktop port open"

  ingress {
    description = "Remote desktop port open"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["fd00::/8"]
  }
}

resource "aws_security_group" "positive1-7" {
  name        = "allow_tls"
  description = "Remote desktop port open"

  ingress {
    description = "Remote desktop port open"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}