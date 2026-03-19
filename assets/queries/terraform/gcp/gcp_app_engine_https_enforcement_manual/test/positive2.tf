resource "google_app_engine_standard_app_version" "app_no_handlers" {
  service    = "backend"
  version_id = "v1"
  runtime    = "go119"
  # FALLO: Falta el bloque handlers, requiere revisión de app.yaml
}