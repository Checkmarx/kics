module "negative4" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  root_block_device = {
    delete_on_termination = true
    encrypted             = true
    throughput            = 0
    volume_size           = 8
    volume_type           = "gp2"
  }

  ebs_block_device {
    device_name           = "/dev/sdh"
    volume_size           = 10         
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }
}

module "negative4-legacy" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = true
      volume_size           = 8
      volume_type           = "gp2"
    }
  ]

  ebs_block_device = [
    {
      device_name           = "/dev/sdh"
      volume_size           = 10
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  ]
}
