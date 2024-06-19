resource "tencentcloud_security_group" "sg" {
  name        = "tf-example"
  description = "Testing Rule Set Security"
}

resource "tencentcloud_security_group_rule_set" "base" {
  security_group_id = tencentcloud_security_group.sg.id

  ingress {
    action      = "ACCEPT"
    cidr_block  = "10.0.0.0/22"
    protocol    = "TCP"
    port        = "80-90"
    description = "A:Allow Ips and 80-90"
  }

  egress {
    action      = "DROP"
    cidr_block  = "10.0.0.0/16"
    protocol    = "ICMP"
    description = "A:Block ping3"
  }
}
