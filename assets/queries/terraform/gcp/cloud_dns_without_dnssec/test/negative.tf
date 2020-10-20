resource "google_dns_managed_zone" "foo" {
  name     = "foobar"
  dns_name = "foo.bar."

  dnssec_config {
    state         = "on"
    non_existence = "nsec3"
  }
}