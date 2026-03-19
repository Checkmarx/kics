resource "google_apikeys_key" "key_fully_secure" {
  name         = "fully-secure-key"
  display_name = "Compliant Key"

  restrictions {
    browser_key_restrictions {
      allowed_referrers = ["https://example.com/*"]
    }

    # CORRECTO: Acceso limitado a servicios específicos
    api_targets {
      service = "translate.googleapis.com"
    }
  }
}