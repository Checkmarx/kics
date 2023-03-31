resource "nifcloud_security_group" "negative" {
  group_name  = "http"
  description = "Allow inbound HTTP traffic"
}
