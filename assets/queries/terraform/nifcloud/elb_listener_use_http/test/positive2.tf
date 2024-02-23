resource "nifcloud_elb_listener" "positive" {
  elb_id        = nifcloud_elb.positive.id
  instance_port = 80
  protocol      = "HTTP"
  lb_port       = 80
}

resource "nifcloud_elb" "positive" {
  availability_zone = "east-11"
  instance_port     = 8080
  protocol          = "HTTP"
  lb_port           = 8080

  network_interface {
    network_id     = "net-COMMON_GLOBAL"
    is_vip_network = true
  }

  network_interface {
    network_id     = "net-COMMON_PRIVATE"
  }
}
