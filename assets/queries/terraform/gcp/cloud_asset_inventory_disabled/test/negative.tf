resource "google_project_service" "negative_1" {
  service            = "cloudasset.googleapis.com"
}

resource "google_project_service" "negative_2" {
  for_each = toset([
    "compute.googleapis.com",
    "cloudasset.googleapis.com",
    "pubsub.googleapis.com",
  ])
  service            = each.value       # using for_each on a "toset"
}

resource "google_project_service" "negative_3" {
  for_each = {
    compute   = "compute.googleapis.com"
    cloudasset = "cloudasset.googleapis.com"
  }
  service = each.value    # using for_each on a set
}

locals {
  apis_toset = toset([
    "compute.googleapis.com",
    "cloudasset.googleapis.com",
    "pubsub.googleapis.com",
  ])
  apis_set = {
    compute   = "compute.googleapis.com"
    cloudasset = "cloudasset.googleapis.com"
  }
}

resource "google_project_service" "negative_4" {
  for_each = local.apis_toset         # using toset "locals" variables
  service  = each.value
}

resource "google_project_service" "negative_5" {
  for_each = local.apis_set         # using a set with "locals" variables
  service  = each.value
}
