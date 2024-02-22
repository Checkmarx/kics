resource "nifcloud_db_security_group" "negative" {
  group_name        = "example"
  availability_zone = "east-11"
  rule {
    cidr_ip = "10.0.0.0/16"
  }
}
