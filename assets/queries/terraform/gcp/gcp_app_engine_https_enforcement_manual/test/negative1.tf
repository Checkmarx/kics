resource "google_app_engine_standard_app_version" "app_secure" {
  service    = "frontend"
  version_id = "v1"
  runtime    = "php81"

  handlers {
    url_regex      = "/.*"
    security_level = "SECURE_ALWAYS"
  }
}