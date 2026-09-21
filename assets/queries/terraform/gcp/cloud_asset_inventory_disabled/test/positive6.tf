locals {
  apis_set = {
    compute   = "compute.googleapis.com"
    pubsub    = "pubsub.googleapis.com"
  }
}

resource "google_project_service" "positive_6" {
  for_each = local.apis_set
  service  = each.value
}
