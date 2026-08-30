resource "google_compute_instance" "vm_fail_2" {
  name         = "instance-no-flag"
  metadata = {
    foo = "bar"
  }
}