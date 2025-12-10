resource "google_project_service" "negative_3" {
  for_each = {
    compute   = "compute.googleapis.com"
    cloudasset = "cloudasset.googleapis.com"
  }
  service = each.value    # using for_each on a set
}
