resource "aws_security_group" "positive6" {
  name        = "allow_tls6"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 135
    to_port     = 170
    protocol    = "udp"
    cidr_blocks = ["10.68.0.0", "172.16.0.0/12"]
  }
}
