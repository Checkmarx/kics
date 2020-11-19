#this is a problematic code where the query should report a result(s)
resource "aws_security_group" "http_positive_tcp_1" {
  name        = "http_positive_tcp_1"
  description = "Gets the http port open with the tcp protocol"

  ingress {
    description = "HTTP port open"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
}

resource "aws_security_group" "http_positive_udp_1" {
  name        = "http_positive_udp_1"
  description = "Gets the http port open with the udp protocol"

  ingress {
    description = "HTTP port open"
    from_port   = 80
    to_port     = 80
    protocol    = "udp"
  }
}