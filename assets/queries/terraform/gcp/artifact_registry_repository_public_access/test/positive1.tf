resource "google_artifact_registry_repository_iam_member" "positive1" {
  repository = google_artifact_registry_repository.my_repo.name
  location   = google_artifact_registry_repository.my_repo.location
  role       = "roles/artifactregistry.reader"
  member     = "allUsers"
}
