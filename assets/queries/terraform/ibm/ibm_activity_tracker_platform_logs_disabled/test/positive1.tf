provider "ibm" {
  region = "eu-de"
}

# No hay activity-tracker
resource "ibm_is_vpc" "vpc_test" {
  name = "test-vpc"
}