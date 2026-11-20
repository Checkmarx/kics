resource "google_compute_backend_service" "fail_disabled_log" {
  name = "backend-disabled-logs"
  
  log_config {
    enable = false # FAIL: Should be true
  }
}