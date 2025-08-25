resource "aws_security_group" "positive1-1" {
  name        = "allow_tls"
  description = "SQL Analysis Services port open"

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2300
    to_port     = 2400
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16", "0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-2" {
  name        = "allow_tls"
  description = "SQL Analysis Services port open"

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2380
    to_port     = 2390
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16"]
  }

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2350
    to_port     = 2384
    protocol    = "tcp"
    cidr_blocks = ["192.121.0.0/16", "0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-3" {
  name        = "allow_tls"
  description = "SQL Analysis Services port open"

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2300
    to_port     = 2400
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "positive1-4" {
  name        = "allow_tls"
  description = "SQL Analysis Services port open"

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2380
    to_port     = 2390
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd01::/8"]
  }

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2350
    to_port     = 2384
    protocol    = "tcp"
    ipv6_cidr_blocks = ["fd00::/8", "::/0"]
  }
}

resource "aws_security_group" "positive1-5" {
  name        = "allow_tls"
  description = "SQL Analysis Services port open"

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
    cidr_blocks = ["192.120.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "positive1-6" {
  name        = "allow_tls"
  description = "SQL Analysis Services port open"

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["fd00::/8"]
  }
}

resource "aws_security_group" "positive1-7" {
  name        = "allow_tls"
  description = "SQL Analysis Services port open"

  ingress {
    description = "SQL Analysis Services port open"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}