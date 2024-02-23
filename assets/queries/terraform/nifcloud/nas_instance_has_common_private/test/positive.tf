resource "nifcloud_nas_instance" "positive" {
  identifier        = "nas001"
  allocated_storage = 100
  protocol          = "nfs"
  type              = 0
  network_id        = "net-COMMON_PRIVATE"
}
