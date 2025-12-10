resource "google_compute_network" "vpc_network_network" {
  name = "vpc-legacy"
  auto_create_subnetworks = true
}