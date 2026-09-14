provider "ibm" {
  region = "eu-de"
}

resource "ibm_resource_instance" "tracker_compliant" {
  name          = "activity-tracker-secure"
  service       = "activity-tracker"
  plan          = "7-day"
  location      = "eu-de"
  platform_logs = true
}