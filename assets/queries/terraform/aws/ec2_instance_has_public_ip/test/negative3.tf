module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_network_interface" "this" {
  subnet_id       = var.private_subnet_id
  security_groups = [aws_security_group.this.id]
}

resource "aws_security_group" "this" {
  name        = "example"
  description = "Example Security Group"
}
