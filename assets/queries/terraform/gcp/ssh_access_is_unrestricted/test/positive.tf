resource "google_compute_firewall" "ssh_allowed_port" {
  name    = "test-firewall"
  network = google_compute_network.default.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_firewall" "ssh_allowed_range" {
  name    = "test-firewall"
  network = google_compute_network.default.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000","21-3390"]
  }

  source_tags = ["web"]
}