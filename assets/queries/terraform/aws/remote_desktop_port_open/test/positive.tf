#this is a problematic code where the query should report a result(s)
resource "aws_security_group" "tcp_positive" {

  ingress {
    description = "Remote desktop port open"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
  }
}

resource "aws_security_group" "udp_positive" {

  ingress {
    description = "Remote desktop port open"
    from_port   = 3389
    to_port     = 3389
    protocol    = "udp"
  }
}