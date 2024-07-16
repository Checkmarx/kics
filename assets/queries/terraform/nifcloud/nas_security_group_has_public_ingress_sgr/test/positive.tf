resource "nifcloud_nas_security_group" "positive" {
  group_name        = "nasgroup001"
  availability_zone = "east-11"

  rule {
    cidr_ip = "0.0.0.0/0"
  }
}
