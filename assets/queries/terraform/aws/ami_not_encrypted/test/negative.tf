#this code is a correct code for which the query should not find any result
resource "aws_ami" "negative1" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda2"

  ebs_block_device {
    device_name = "/dev/xvda2"
    snapshot_id = "snap-xxxxxxxx"
    volume_size = 8
	encrypted   = true
  }
}