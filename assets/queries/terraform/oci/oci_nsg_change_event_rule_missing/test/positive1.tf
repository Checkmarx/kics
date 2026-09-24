provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_network_security_group" "test_nsg" {
  compartment_id = "ocid1.compartment..."
  display_name   = "test-nsg"
  vcn_id         = "ocid1.vcn..."
}