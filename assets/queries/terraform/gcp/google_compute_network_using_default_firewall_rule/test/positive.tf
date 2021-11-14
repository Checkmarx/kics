resource "google_compute_firewall" "positive1" {
  name    = "default"
  network = google_compute_network.positive1.name
}

resource "google_compute_network" "positive1" {
  name = "test-network"
}
