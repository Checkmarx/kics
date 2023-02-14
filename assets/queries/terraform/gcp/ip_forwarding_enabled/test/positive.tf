resource "google_compute_instance" "appserver" {
  name           = "primary-application-server"
  can_ip_forward = true
  machine_type   = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
  }
}
