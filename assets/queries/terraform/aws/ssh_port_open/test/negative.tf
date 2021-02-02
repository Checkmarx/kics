resource "aws_security_group" "negative_ssh_1" {
  name        = "negative_http"
  description = "Doesn't get the htttp port open"
}

resource "aws_security_group" "negative_ssh_2" {

  ingress {
    from_port   = 24
    to_port     = 30
    protocol    = "tcp"
  }
}

resource "aws_security_group" "negative_ssh_3" {

  ingress {
    from_port   = 10
    to_port     = 30
    protocol    = "tcp"
    cidr_blocks = ["0.1.0.0/0"]
  }
}
