# "Google OAuth" - d651cca2-2156-4d17-8e76-423e68de5c8b  positive-test
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id = "53221331-2323wasdfa343rwhthfaf33feaf2fa7f.apps.googleusercontent.com"  # positive1
    client_secret = "j2323232324"
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}
