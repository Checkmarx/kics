#this is a problematic code where the query should report a result(s)
data "google_compute_instance" "appserver1" {
  name = "primary-application-server"
  zone = "us-central1-a"
}

data "google_compute_instance" "appserver2" {
  name = "primary-application-server"
  zone = "us-central1-a"
  shielded_instance_config {
      enable_secure_boot = true
      enable_vtpm = true
  }
}

data "google_compute_instance" "appserver3" {
  name = "primary-application-server"
  zone = "us-central1-a"
  shielded_instance_config {
      enable_secure_boot = true
      enable_integrity_monitoring = true
  }
}

data "google_compute_instance" "appserver4" {
  name = "primary-application-server"
  zone = "us-central1-a"
  shielded_instance_config {
      enable_vtpm = true
      enable_integrity_monitoring = true
  }
}

data "google_compute_instance" "appserver5" {
  name = "primary-application-server"
  zone = "us-central1-a"
  shielded_instance_config {
      enable_secure_boot = false
      enable_vtpm = true
      enable_integrity_monitoring = true
  }
}

data "google_compute_instance" "appserver6" {
  name = "primary-application-server"
  zone = "us-central1-a"
  shielded_instance_config {
      enable_secure_boot = true
      enable_vtpm = false
      enable_integrity_monitoring = true
  }
}

data "google_compute_instance" "appserver7" {
  name = "primary-application-server"
  zone = "us-central1-a"
  shielded_instance_config {
      enable_secure_boot = true
      enable_vtpm = true
      enable_integrity_monitoring = false
  }
}