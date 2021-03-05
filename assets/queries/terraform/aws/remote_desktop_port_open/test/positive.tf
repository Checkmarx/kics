resource "aws_security_group" "positive1" {
  name        = "rdp_positive_tcp_1"
  description = "Gets the remote desktop port open with the tcp protocol"

  ingress {
    description = "Remote desktop port open"
    from_port   = 3380
    to_port     = 3450
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive2" {
  name        = "rdp_positive_tcp_2"
  description = "Gets the remote desktop port open with the tcp protocol"

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
