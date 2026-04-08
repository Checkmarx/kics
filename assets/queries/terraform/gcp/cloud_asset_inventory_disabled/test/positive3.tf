resource "google_project_service" "positive_3" {
  for_each = {
    compute   = "compute.googleapis.com"
    pubsub    = "pubsub.googleapis.com"
  }
  service = each.value
}
