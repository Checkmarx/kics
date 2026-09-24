provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_compartment" "example" {
  compartment_id = "ocid1.tenancy..."
  name           = "example_compartment"
  description    = "Just a compartment"
}