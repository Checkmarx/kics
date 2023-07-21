resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id = "53221331-2323wasdfa343rwhthfaf33feaf2fa7f.apps.googleusercontent.com"
    client_secret = "F-oS9Su%}<>[];#"
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}
