resource "nifcloud_router" "negative" {
  security_group  = nifcloud_security_group.example.group_name

  network_interface {
    network_id = nifcloud_private_lan.main.id
  }
}
