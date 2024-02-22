resource "nifcloud_nas_security_group" "negative" {
  group_name  = "app"
  description = "Allow from app traffic"
}
