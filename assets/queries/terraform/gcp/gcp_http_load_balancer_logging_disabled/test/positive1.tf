resource "google_compute_backend_service" "fail_missing_log" {
  name     = "backend-no-logs"
  protocol = "HTTP"
  # FALLO: No tiene bloque log_config
}