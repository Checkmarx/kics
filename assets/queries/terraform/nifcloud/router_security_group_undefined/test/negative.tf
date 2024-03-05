resource "nifcloud_router" "negative" {
  security_group = nifcloud_security_group.router.group_name

  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }
}
