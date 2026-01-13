resource "google_project_service" "positive1_1" {
  service            = "not_cloudasset.googleapis.com"
}

resource "google_project_service" "positive1_2" {
  service            = "not_cloudasset.googleapis.com_2"
}
