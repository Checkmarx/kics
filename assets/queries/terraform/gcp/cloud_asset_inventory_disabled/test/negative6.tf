locals {
  apis_set = {
    compute   = "compute.googleapis.com"
    cloudasset = "cloudasset.googleapis.com"
  }
}

resource "google_project_service" "negative_6" {
  for_each = local.apis_set         # using apis_set from "locals" variables
  service  = each.value
}
