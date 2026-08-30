provider "ibm" {
  region = "us-south"
}

resource "ibm_resource_instance" "tracker_wrong_location" {
  name     = "regional-tracker"
  service  = "activity-tracker"
  plan     = "lite"
  location = "us-east" # FALLO: No soporta eventos globales
}