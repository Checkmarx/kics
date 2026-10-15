resource "google_compute_instance" "vm_fail_1" {
  name         = "instance-no-metadata"
  machine_type = "e2-medium"
}