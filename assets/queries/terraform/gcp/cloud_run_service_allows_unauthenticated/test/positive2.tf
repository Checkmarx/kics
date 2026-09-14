resource "google_cloud_run_service_iam_binding" "positive2" {
  service  = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  role     = "roles/run.invoker"
  members  = ["allUsers", "serviceAccount:my-sa@project.iam.gserviceaccount.com"]
}
