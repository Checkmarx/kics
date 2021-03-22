resource "aws_security_group" "negative1" {
  name        = "negative_http"
  description = "Doesn't get the HTTP port open"
}

resource "aws_security_group" "negative2" {

  ingress {
    from_port   = 70
    to_port     = 81
    protocol    = "tcp"
  }
}

resource "aws_security_group" "negative3" {

  ingress {
    from_port   = 79
    to_port     = 100
    protocol    = "tcp"
    cidr_blocks = ["0.1.0.0/0"]
  }
}
