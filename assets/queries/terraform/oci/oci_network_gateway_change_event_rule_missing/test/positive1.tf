provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_vcn" "test_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = "ocid1.compartment..."
}