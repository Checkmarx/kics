resource "nifcloud_security_group_rule" "positive" {
  security_group_names = ["http"]
  type                 = "IN"
  description          = "HTTP from VPC"
  from_port            = 80
  to_port              = 80
  protocol             = "TCP"
  cidr_ip              = "0.0.0.0/0"
}
