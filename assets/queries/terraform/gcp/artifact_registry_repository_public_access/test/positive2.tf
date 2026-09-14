resource "google_artifact_registry_repository_iam_binding" "positive2" {
  repository = google_artifact_registry_repository.my_repo.name
  location   = google_artifact_registry_repository.my_repo.location
  role       = "roles/artifactregistry.reader"
  members    = ["allAuthenticatedUsers"]
}
