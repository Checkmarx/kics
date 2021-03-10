resource "aws_security_group" "positive1" {
  name        = "http_positive_tcp_1"
  description = "Gets the HTTP port open with the tcp protocol"

  ingress {
    description = "HTTP port open"
    from_port   = 78
    to_port     = 91
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "positive2" {
  name        = "http_positive_tcp_2"
  description = "Gets the HTTP port open with the tcp protocol"

  ingress {
    description = "HTTP port open"
    from_port   = 60
    to_port     = 85
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.2/0"]
  }

  ingress {
    description = "HTTP port open"
    from_port   = 65
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
