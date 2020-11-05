
resource "aws_ami" "example" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = "snap-xxxxxxxx"
    volume_size = 8
  }
}


resource "aws_ami" "example2" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda1"


  ebs_block_device {
    device_name = "/dev/xvda1"
    snapshot_id = "snap-xxxxxxxx"
    volume_size = 8
	encrypted			  = false
  }
}

resource "aws_ami" "example3" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda1"
}