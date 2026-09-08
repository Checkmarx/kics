# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables" allow-rule-test
resource "auth0_connection" "google_oauth2" {
  name = "Google-OAuth2-Connection"
  strategy = "google-oauth2"
  options {
    client_id     = var.google_client_id
    client_secret = var.google_client_secret  # negative1
    allowed_audiences = [ "example.com", "api.example.com" ]
    scopes = [ "email", "profile", "gmail", "youtube" ]
    set_user_root_attributes = "on_each_login"
  }
}
