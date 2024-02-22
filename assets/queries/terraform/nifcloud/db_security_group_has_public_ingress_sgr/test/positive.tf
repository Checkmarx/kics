resource "nifcloud_db_security_group" "positive" {
  group_name        = "example"
  availability_zone = "east-11"
  rule {
    cidr_ip = "0.0.0.0/0"
  }
}
