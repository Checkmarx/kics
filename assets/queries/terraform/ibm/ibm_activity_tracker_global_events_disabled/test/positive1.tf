provider "ibm" {
  region = "us-south"
}

resource "ibm_is_vpc" "example_vpc" {
  name = "production-vpc"
}