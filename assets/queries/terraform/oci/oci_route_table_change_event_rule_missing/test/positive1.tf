provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_route_table" "test_rt" {
  compartment_id = "ocid1.compartment..."
  vcn_id         = "ocid1.vcn..."
  display_name   = "test-rt"
}