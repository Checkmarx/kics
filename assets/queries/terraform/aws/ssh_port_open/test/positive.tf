resource "aws_security_group" "ssh_positive_tcp_1" {
  name        = "ssh_positive_tcp_1"
  description = "Gets the ssh port open with the tcp protocol"

  ingress {
    description = "SSH port open"
    from_port   = 15
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_positive_udp_1" {
  name        = "ssh_positive_udp_1"
  description = "Gets the ssh port open with the udp protocol"

  ingress {
    description = "SSH port open"
    from_port   = 18
    to_port     = 23
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
