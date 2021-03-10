resource "google_dns_managed_zone" "positive1" {
    name        = "example-zone"
    dns_name    = "example-${random_id.rnd.hex}.com."
    description = "Example DNS zone"
    labels = {
        foo = "bar"
    }

    dnssec_config {
        default_key_specs{
            algorithm = "rsasha1"
        }
    }
}
