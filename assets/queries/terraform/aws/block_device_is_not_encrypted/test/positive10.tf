module "positive10" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name           = "web-app-instance"
  ami            = "ami-074251216af698218"
  instance_type  = "t2.micro"

  root_block_device = {
    throughput            = 0
    volume_size           = 8
    volume_type           = "gp2"
  }

  tags = {
    Name = "web-app-instance"
  }
}
