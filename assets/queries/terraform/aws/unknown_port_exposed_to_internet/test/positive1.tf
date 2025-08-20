resource "aws_security_group" "positive1-1" {
  name        = "allow_tls_1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 44
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "positive1-2" {
  name        = "allow_tls_2"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/24", "0.0.0.0/0"]
  }

  ingress {
    from_port   = 18
    to_port     = 18
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/24", "0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive1-3" {

  ingress {
    description = "Remote desktop open private"
    from_port   = 600
    to_port     = 1200
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
}
