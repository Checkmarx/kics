locals {
  apis_toset = toset([
    "compute.googleapis.com",
    "cloudasset.googleapis.com",
    "pubsub.googleapis.com",
  ])
}

resource "google_project_service" "negative_5" {
  for_each = local.apis_toset         # using apis_toset from "locals" variables
  service  = each.value
}
