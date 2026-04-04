resource "google_container_cluster" "positive1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  node_config {
    service_account = google_service_account.default.email
    shielded_instance_config {
      enable_integrity_monitoring = false
    }
  }
}  