resource "nifcloud_vpn_gateway" "negative" {
  security_group  = nifcloud_security_group.example.group_name

  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }
}
