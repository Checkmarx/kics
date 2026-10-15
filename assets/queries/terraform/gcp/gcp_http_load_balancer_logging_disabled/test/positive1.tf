resource "google_compute_backend_service" "fail_missing_log" {
  name     = "backend-no-logs"
  protocol = "HTTP"
  # FAIL: No tiene bloque log_config
}