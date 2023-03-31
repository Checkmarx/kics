resource "nifcloud_instance" "positive" {
  image_id        = data.nifcloud_image.ubuntu.id
  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }
}
