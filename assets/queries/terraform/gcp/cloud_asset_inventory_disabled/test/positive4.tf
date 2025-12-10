locals {
  api = "not_cloudasset.googleapis.com"
}

resource "google_project_service" "positive_4" {
  for_each = local.api
  service  = each.value
}
