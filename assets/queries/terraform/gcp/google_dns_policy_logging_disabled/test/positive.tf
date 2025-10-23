resource "google_dns_policy" "example-policy" {
  name                      = "example-policy"
  enable_inbound_forwarding = true

}

resource "google_dns_policy" "example-policy-2" {
  name                      = "example-policy-2"
  enable_inbound_forwarding = true

  enable_logging = false
}
