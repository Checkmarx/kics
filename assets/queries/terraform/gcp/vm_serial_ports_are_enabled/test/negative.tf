resource "google_compute_instance" "some_metadata" {
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
    serial-port-enable = "FALSE"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_project_metadata" "more_metadata" {
  metadata = {
    serial-port-enable = false
  }
}

resource "google_compute_project_metadata_item" "yet_another_metadata" {
  key   = "my_metadata"
  value = "my_value"
}
