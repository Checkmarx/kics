resource "google_compute_firewall" "rdp_allowed_port" {
  name    = "test-firewall"
  network = google_compute_network.default.name
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000","3389"]
  }

  source_tags = ["web"]
}

resource "google_compute_firewall" "rdp_allowed_range" {
  name    = "test-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "udp"
    ports    = ["80", "8080", "1000-2000","21-3390"]
  }

  source_tags = ["web"]
}