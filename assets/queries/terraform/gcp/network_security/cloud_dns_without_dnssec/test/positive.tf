// comment
// comment
// comment
// comment
resource "google_dns_managed_zone" "foo" {
  name     = "foobar"
  dns_name = "foo.bar."

  dnssec_config {
    state         = "off"
    non_existence = "nsec3"
  }
}