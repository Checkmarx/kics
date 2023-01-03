resource "google_compute_firewall" "positive1" {
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

resource "google_compute_firewall" "positive2" {
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

resource "google_compute_firewall" "positive3" {
  name    = "test-firewall"
  network = google_compute_network.default.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "all"
  }

  source_tags = ["web"]
}
