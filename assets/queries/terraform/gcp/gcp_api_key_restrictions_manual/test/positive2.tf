resource "google_apikeys_key" "key_with_restrictions" {
  name         = "restricted-key"
  display_name = "Restricted Key"

  restrictions {
    # INFO: This section requires manual verification of the values
    server_key_restrictions {
      allowed_ips = ["192.168.1.1"]
    }
  }
}