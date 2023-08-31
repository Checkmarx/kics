resource "nifcloud_instance" "positive" {
  image_id        = data.nifcloud_image.ubuntu.id
  security_group  = nifcloud_security_group.example.group_name
  network_interface {
    network_id = "net-COMMON_PRIVATE"
  }
}
