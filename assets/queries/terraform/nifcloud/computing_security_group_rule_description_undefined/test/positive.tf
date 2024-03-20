resource "nifcloud_security_group_rule" "positive" {
  security_group_names = ["http"]
  type                 = "IN"
  from_port            = 80
  to_port              = 80
  protocol             = "TCP"
  cidr_ip              = nifcloud_private_lan.main.cidr_block
}
