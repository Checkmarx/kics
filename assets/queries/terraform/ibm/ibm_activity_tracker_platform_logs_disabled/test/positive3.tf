provider "ibm" {
  region = "eu-de"
}

resource "ibm_resource_instance" "tracker_disabled" {
  name     = "activity-tracker-off"
  service  = "activity-tracker"
  plan     = "lite"
  location = "eu-de"
  
  # FALLO: Deshabilitado explícitamente
  platform_logs = false
}