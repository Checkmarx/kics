resource "nifcloud_elb" "positive" {
  availability_zone = "east-11"
  instance_port     = 80
  protocol          = "HTTP"
  lb_port           = 80

  network_interface {
    network_id     = "net-COMMON_GLOBAL"
    is_vip_network = true
  }
}
