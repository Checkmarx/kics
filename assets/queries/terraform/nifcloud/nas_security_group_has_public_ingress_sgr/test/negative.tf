resource "nifcloud_nas_security_group" "negative" {
  group_name        = "nasgroup001"
  availability_zone = "east-11"

  rule {
    cidr_ip = "10.0.0.0/16"
  }
}
