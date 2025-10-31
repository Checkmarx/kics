locals {
  api = "cloudasset.googleapis.com"
}

resource "google_project_service" "negative_4" {
  for_each = local.api              # using the "api" from "locals" variables
  service  = each.value
}
