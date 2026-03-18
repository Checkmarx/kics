provider "ibm" {
  region = "us-south"
}

resource "ibm_resource_instance" "tracker_correct" {
  name     = "global-tracker"
  service  = "activity-tracker"
  plan     = "7-day"
  location = "us-south" # CORRECTO: Región de eventos globales (Dallas)
}