resource "google_project" "example_project" {
  name       = "My Project"
  project_id = "bad"
  org_id     = "1234567"
}

resource "google_compute_network" "vpc_network_network" {
  name = "vpc-legacy"
  project = google_project.example_project.id
}