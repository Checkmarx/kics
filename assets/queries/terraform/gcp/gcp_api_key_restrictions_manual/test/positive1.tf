resource "google_apikeys_key" "key_public" {
  name         = "public-key"
  display_name = "Public Key"
  project      = "my-project"
  # FALLO: No tiene bloque restrictions
}