resource "google_compute_instance" "vm_ok" {
  name         = "instance-compliant"
  metadata = {
    "google-logging-enabled" = "true"
  }
}