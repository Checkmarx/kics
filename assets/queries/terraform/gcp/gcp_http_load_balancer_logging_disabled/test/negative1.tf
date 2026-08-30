resource "google_compute_backend_service" "pass_logs" {
  name = "backend-with-logs"
  
  log_config {
    enable      = true
    sample_rate = 1.0
  }
}