module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "1.0.4"

  ebs_block_device = [
     {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    }
  ]

  root_block_device = [
     {
      volume_size = "50"
      volume_type = "gp2"
     }
  ]
}

module "asg2" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.0"

  block_device_mappings = [
    { 
      ebs = {  # Root device
        volume_size           = 50
        volume_type           = "gp2"
      }
    },
    {
      device_name = "/dev/xvdz" # EBS device
      ebs = {
        volume_size           = 50
        volume_type           = "gp2"
        delete_on_termination = true
      }
    }
  ]
}