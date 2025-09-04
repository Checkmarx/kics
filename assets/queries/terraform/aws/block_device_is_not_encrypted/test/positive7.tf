module "positive7-aws6" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name           = "web-app-instance"
  ami            = "ami-074251216af698218"
  instance_type  = "t2.micro"

  root_block_device = {
    delete_on_termination = true
    encrypted             = false
    throughput            = 0
    volume_size           = 8
    volume_type           = "gp2"
  }
}

module "positive7-legacy" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.7"

  name           = "web-app-instance"
  ami            = "ami-074251216af698218"
  instance_type  = "t2.micro"

  root_block_device = [
    {
    delete_on_termination = true
    encrypted             = false
    throughput            = 0
    volume_size           = 8
    volume_type           = "gp2"
   }
  ]
}

