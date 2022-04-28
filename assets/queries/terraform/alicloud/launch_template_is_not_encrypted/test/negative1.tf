data "alicloud_images" "images" {
  owners = "system"
}

data "alicloud_instances" "instances" {
}

resource "alicloud_launch_template" "templateneg1" {
  name                          = "tf-test-template"
  description                   = "test1"
  image_id                      = data.alicloud_images.images.images[0].id
  host_name                     = "tf-test-host"
  instance_charge_type          = "PrePaid"
  instance_name                 = "tf-instance-name"
  instance_type                 = data.alicloud_instances.instances.instances[0].instance_type
  internet_charge_type          = "PayByBandwidth"
  internet_max_bandwidth_in     = 5
  internet_max_bandwidth_out    = 0
  io_optimized                  = "none"
  key_pair_name                 = "test-key-pair"
  ram_role_name                 = "xxxxx"
  network_type                  = "vpc"
  security_enhancement_strategy = "Active"
  spot_price_limit              = 5
  spot_strategy                 = "SpotWithPriceLimit"
  security_group_id             = "sg-zxcvj0lasdf102350asdf9a"
  system_disk_category          = "cloud_ssd"
  system_disk_description       = "test disk"
  system_disk_name              = "hello"
  system_disk_size              = 40
  resource_group_id             = "rg-zkdfjahg9zxncv0"
  userdata                      = "xxxxxxxxxxxxxx"
  vswitch_id                    = "sw-ljkngaksdjfj0nnasdf"
  vpc_id                        = "vpc-asdfnbg0as8dfk1nb2"
  zone_id                       = "beijing-a"
  encrypted                     = true

  tags = {
    tag1 = "hello"
    tag2 = "world"
  }
  network_interfaces {
    name              = "eth0"
    description       = "hello1"
    primary_ip        = "10.0.0.2"
    security_group_id = "xxxx"
    vswitch_id        = "xxxxxxx"
  }
  data_disks {
    name        = "disk1"
    description = "test1"
  }
  data_disks {
    name        = "disk2"
    description = "test2"
  }
}
