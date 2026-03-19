resource "google_app_engine_standard_app_version" "app_insecure" {
  service    = "default"
  version_id = "v1"
  runtime    = "python39"

  handlers {
    url_regex = "/.*"
    # FALLO: security_level no es SECURE_ALWAYS
    security_level = "SECURE_OPTIONAL"
  }
}