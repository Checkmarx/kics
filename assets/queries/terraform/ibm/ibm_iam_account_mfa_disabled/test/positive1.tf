provider "ibm" {
  region = "us-south"
}

# Solo recursos de infraestructura, nada de IAM settings
resource "ibm_is_vpc" "example" {
  name = "test-vpc"
}