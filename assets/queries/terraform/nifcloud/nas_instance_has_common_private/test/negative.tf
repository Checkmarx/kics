resource "nifcloud_nas_instance" "negative" {
  identifier        = "nas001"
  allocated_storage = 100
  protocol          = "nfs"
  type              = 0
  network_id        = nifcloud_private_lan.main.id
}
