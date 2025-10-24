resource "google_project_service" "positive_1" {
  service            = "not_cloudasset.googleapis.com"
}

resource "google_project_service" "positive_2" {
  for_each = toset([
    "compute.googleapis.com",
    "pubsub.googleapis.com",
  ])
  service            = each.value
}

resource "google_project_service" "positive_3" {
  for_each = {
    compute   = "compute.googleapis.com"
    pubsub    = "pubsub.googleapis.com"
  }
  service = each.value
}

locals {
  api = "not_cloudasset.googleapis.com"
  apis_toset = toset([
    "compute.googleapis.com",
    "pubsub.googleapis.com",
  ])
  apis_set = {
    compute   = "compute.googleapis.com"
    pubsub    = "pubsub.googleapis.com"
  }
}

resource "google_project_service" "positive_4" {
  for_each = local.api
  service  = each.value
}

resource "google_project_service" "positive_5" {
  for_each = local.apis_toset
  service  = each.value
}

resource "google_project_service" "positive_6" {
  for_each = local.apis_set
  service  = each.value
}
