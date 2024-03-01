resource "tencentcloud_cbs_storage" "encrytion_negative1" {
  storage_name      = "cbs-test"
  storage_type      = "CLOUD_SSD"
  storage_size      = 100
  availability_zone = "ap-guangzhou-3"
  encrypt           = true

  tags = {
    test = "tf"
  }
}
