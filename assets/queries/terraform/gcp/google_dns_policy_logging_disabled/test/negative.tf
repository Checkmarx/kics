resource "google_dns_policy" "example-policy" {
  name                      = "example-policy"
  enable_inbound_forwarding = true

  enable_logging = true
}
