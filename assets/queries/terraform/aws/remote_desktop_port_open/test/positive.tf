#this is a problematic code where the query should report a result(s)
resource "aws_security_group" "tcp_positive" {

  ingress {
    description = "Remote desktop port open"
    from_port   = 3380
    to_port     = 3450
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "udp_positive" {

  ingress {
    description = "Remote desktop port open"
    from_port   = 3381
    to_port     = 3445
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}