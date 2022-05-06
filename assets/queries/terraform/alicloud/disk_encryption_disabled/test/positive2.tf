resource "alicloud_disk" "disk_encryption2" {
  # cn-beijing
  availability_zone = "cn-beijing-b"
  name              = "New-disk"
  description       = "Hello ecs disk."
  category          = "cloud_efficiency"
  size              = "30"
  encrypted         = false
  kms_key_id        = "2a6767f0-a16c-4679-a60f-13bf*****"
  tags = {
    Name = "TerraformTest"
  }
}
