resource "nifcloud_elb_listener" "negative" {
  elb_id        = nifcloud_elb.negative.id
  instance_port = 1443
  protocol      = "HTTPS"
  lb_port       = 1443
}

resource "nifcloud_elb" "negative" {
  availability_zone = "east-11"
  instance_port     = 443
  protocol          = "HTTPS"
  lb_port           = 443

  network_interface {
    network_id     = "net-COMMON_GLOBAL"
    is_vip_network = true
  }
}
