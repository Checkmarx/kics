resource "aws_security_group" "positive1" {
  name        = "allow_tls_1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 2300
    to_port     = 2400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "positive2" {
  name        = "allow_tls_2"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 2380
    to_port     = 2390
    protocol    = "tcp"
    cidr_blocks = ["0.1.0.0/0"]
  }

   ingress {
    description = "TLS from VPC"
    from_port   = 2350
    to_port     = 2384
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
