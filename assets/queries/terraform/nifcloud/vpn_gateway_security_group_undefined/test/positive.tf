resource "nifcloud_vpn_gateway" "positive" {
  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }
}
