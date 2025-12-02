provider "google-beta" {
  project = "my-sample-project-12345"
  region  = "us-central1"
}

resource "google_project" "example_project" {
  name       = "example-project"
  project_id = "my-sample-project-12345"
  org_id     = "123456789012"
}

resource "google_compute_network" "legacy_network" {
  name                    = "legacy-network"
  auto_create_subnetworks = true
}