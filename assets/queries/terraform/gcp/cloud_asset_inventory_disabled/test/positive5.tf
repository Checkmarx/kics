locals {
  apis_toset = toset([
    "compute.googleapis.com",
    "pubsub.googleapis.com",
  ])
}

resource "google_project_service" "positive_5" {
  for_each = local.apis_toset
  service  = each.value
}
