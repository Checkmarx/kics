resource "google_compute_instance" "vm_fail_3" {
  name         = "instance-disabled"
  metadata = {
    "google-logging-enabled" = "false"
  }
}