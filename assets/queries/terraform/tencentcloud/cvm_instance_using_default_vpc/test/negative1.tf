resource "tencentcloud_vpc" "vpc" {
  name       = "tf_example"
  cidr_block = "10.0.0.0/16"
}

resource "tencentcloud_subnet" "subnet" {
  name              = "tf_example"
  vpc_id            = tencentcloud_vpc.vpc.id
  availability_zone = "ap-guangzhou-7"
  cidr_block        = "10.0.1.0/24"
}

resource "tencentcloud_instance" "cvm_postpaid" {
  instance_name     = "cvm_postpaid"
  availability_zone = "ap-guangzhou-7"
  image_id          = "img-9qrfy1xt"
  instance_type     = "SA2.MEDIUM4"
  system_disk_type  = "CLOUD_PREMIUM"
  system_disk_size  = 50
  hostname          = "user"
  project_id        = 0
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.subnet.id

  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  tags = {
    tagKey = "tagValue"
  }
}
