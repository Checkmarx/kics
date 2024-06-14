resource "tencentcloud_instance" "cvm_postpaid" {
  instance_name      = "cvm_postpaid"
  availability_zone  = "ap-guangzhou-7"
  image_id           = "img-9qrfy1xt"
  instance_type      = "POSTPAID_BY_HOUR"
  system_disk_type   = "CLOUD_PREMIUM"
  system_disk_size   = 50
  hostname           = "root"
  project_id         = 0
  vpc_id             = "vpc-axrsmmrv"
  subnet_id          = "subnet-861wd75e"
  allocate_public_ip = false

  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  tags = {
    tagKey = "tagValue"
  }
}
