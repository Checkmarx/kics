resource "nifcloud_elb" "negative" {
  availability_zone = "east-11"
  instance_port     = 80
  protocol          = "HTTP"
  lb_port           = 80
  network_interface {
    network_id = nifcloud_private_lan.main.id
  }
}
