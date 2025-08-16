resource "aws_security_group" "ec2" {
  name        = "Dont open remote desktop port"
  description = "Doesn't enable the remote desktop port"
}

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
