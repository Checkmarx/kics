resource "google_compute_firewall" "negative1" {
  name    = "test-firewall"
  network = google_compute_network.negative1.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "negative1" {
  name = "test-network"
}
