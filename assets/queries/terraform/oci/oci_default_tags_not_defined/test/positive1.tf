provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_vcn" "simple_vcn" {
  compartment_id = "ocid1.compartment..."
  cidr_block     = "10.0.0.0/16"
}