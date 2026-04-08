resource "google_project_service" "negative_2" {
  for_each = toset([
    "compute.googleapis.com",
    "cloudasset.googleapis.com",
    "pubsub.googleapis.com",
  ])
  service            = each.value       # using for_each on a "toset"
}
