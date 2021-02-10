resource "google_compute_instance" "serial_port_enabled" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata = {
    serial-port-enable = true
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_project_metadata" "another_serial_port_enabled" {
  metadata = {
    serial-port-enable = "TRUE"
  }
}

resource "google_compute_project_metadata_item" "yet_another_serial_port_enabled" {
  key   = "serial-port-enable"
  value = "TRUE"
}
