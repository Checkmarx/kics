resource "tencentcloud_security_group" "sg" {
  name        = "tf-example"
  description = "Testing Rule Set Security"
}

resource "tencentcloud_security_group_rule_set" "base" {
  security_group_id = tencentcloud_security_group.sg.id

  ingress {
    action     = "ACCEPT"
    cidr_block = "0.0.0.0/0"
  }
}
