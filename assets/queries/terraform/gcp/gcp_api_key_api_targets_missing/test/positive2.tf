resource "google_apikeys_key" "key_no_targets" {
  name         = "partial-restricted-key"
  display_name = "Key without API targets"

  restrictions {
    server_key_restrictions {
      allowed_ips = ["1.2.3.4"]
    }
    # FAIL: Missing The block api_targets
  }
}