resource "google_apikeys_key" "key_no_restrictions" {
  name         = "unrestricted-key"
  display_name = "Unrestricted Key"
  project      = "my-project"
}