module "negative2" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.0"

  block_device_mappings = [
    {
      device_name = "/dev/xvda" # Root volume
      ebs = {
        volume_size           = 50
        volume_type           = "gp2"
        delete_on_termination = true
        encrypted             = true
      }
    },
    {
      device_name = "/dev/xvdz" # Additional EBS volume
      ebs = {
        volume_size           = 50
        volume_type           = "gp2"
        delete_on_termination = true
        encrypted             = true
      }
    }
  ]
}

module "negative2-legacy" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "1.0.4"

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
      encrypted             = true
    }
 ]

  root_block_device = [ 
    {
      volume_size = "50"
      volume_type = "gp2"
      encrypted   = true
    }
  ]
}
