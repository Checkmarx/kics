resource "google_apikeys_key" "key_with_restrictions" {
  name         = "restricted-key"
  display_name = "Restricted Key"

  restrictions {
    # INFO: Esta sección requiere verificación manual de los valores
    server_key_restrictions {
      allowed_ips = ["192.168.1.1"]
    }
  }
}