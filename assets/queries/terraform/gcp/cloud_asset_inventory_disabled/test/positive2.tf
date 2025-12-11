resource "google_project_service" "positive_2" {
  for_each = toset([
    "compute.googleapis.com",
    "pubsub.googleapis.com",
  ])
  service            = each.value
}
