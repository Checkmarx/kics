resource "aws_security_group" "positive2" { 

  name        = "${var.prefix}-external-http-https"
  description = "Allow main HTTP / HTTPS"
  vpc_id      = local.vpc_id

  ingress {
    description = "Enable HTTP access for select VMs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-external-http-https"
  }
}
