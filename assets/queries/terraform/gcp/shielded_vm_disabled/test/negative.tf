#this code is a correct code for which the query should not find any result
data "google_compute_instance" "appserver" {
  name = "primary-application-server"
  zone = "us-central1-a"
  shielded_instance_config {
      enable_secure_boot = true
      enable_vtpm = true
      enable_integrity_monitoring = true
  }
}