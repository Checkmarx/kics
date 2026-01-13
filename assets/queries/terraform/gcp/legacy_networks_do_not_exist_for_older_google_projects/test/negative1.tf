resource "google_project" "negative1" {
  name       = "My Project"
  project_id = "bad"
  org_id     = "1234567"
}

resource "google_compute_network" "vpc_network_network" {
  name = "vpc-legacy"
  auto_create_subnetworks = false
  project = google_project.negative1.id
}