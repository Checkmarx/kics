data "tencentcloud_instance_types" "c2m2" {
  exclude_sold_out  = true
  cpu_core_count    = 2
  memory_size       = 2
  availability_zone = "ap-hongkong-1"
}

data "tencentcloud_images" "tencent_os" {
  instance_type = data.tencentcloud_instance_types.c2m2.instance_types[0].instance_type
  os_name       = "tencentos"
}

module "cvm" {
  source            = "terraform-tencentcloud-modules/cvm/tencentcloud"
  availability_zone = "ap-guangzhou-7"
  instance_type     = data.tencentcloud_instance_types.c2m2.instance_types[0].instance_type
  image_id          = data.tencentcloud_images.tencent_os.images[0].image_id
}
