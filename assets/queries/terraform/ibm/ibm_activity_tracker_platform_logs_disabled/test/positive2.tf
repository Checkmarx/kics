provider "ibm" {
  region = "eu-de"
}

resource "ibm_resource_instance" "tracker_no_attr" {
  name     = "activity-tracker-missing"
  service  = "activity-tracker"
  plan     = "lite"
  location = "eu-de"
  # FALLO: Falta platform_logs
}