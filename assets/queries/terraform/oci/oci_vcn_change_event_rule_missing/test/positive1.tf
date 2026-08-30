provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_vcn" "test_vcn" {
  compartment_id = "ocid1.compartment.oc1..aaaa"
  cidr_block     = "10.0.0.0/16"
  display_name   = "vulnerable_vcn"
}