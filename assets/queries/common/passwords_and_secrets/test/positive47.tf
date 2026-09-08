# "Google OAuth"   - d651cca2-2156-4d17-8e76-423e68de5c8b  positive-test - #1
# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  positive-test - #2
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id = "53221331-2323wasdfa343rwhthfaf33feaf2fa7f.apps.googleusercontent.com"  #1
    client_secret = "F-oS9Su%}<>[];#"                                                   #2
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}
