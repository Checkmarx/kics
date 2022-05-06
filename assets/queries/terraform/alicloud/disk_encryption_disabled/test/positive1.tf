resource "alicloud_disk" "disk_encryption1" {
  # cn-beijing
  availability_zone = "cn-beijing-b"
  name              = "New-disk"
  description       = "Hello ecs disk."
  category          = "cloud_efficiency"
  size              = "30"
  tags = {
    Name = "TerraformTest"
  }
}

