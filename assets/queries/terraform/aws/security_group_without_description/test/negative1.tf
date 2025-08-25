resource "aws_security_group" "negative1" {
  name        = "negative1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
  
}