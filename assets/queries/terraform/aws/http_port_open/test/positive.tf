#this is a problematic code where the query should report a result(s)
resource "aws_security_group" "http_positive_tcp_1" {
  name        = "http_positive_tcp_1"
  description = "Gets the http port open with the tcp protocol"

  ingress {
    description = "HTTP port open"
    from_port   = 78
    to_port     = 91
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http_positive_udp_1" {
  name        = "http_positive_udp_1"
  description = "Gets the http port open with the udp protocol"

  ingress {
    description = "HTTP port open"
    from_port   = 60
    to_port     = 85
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 