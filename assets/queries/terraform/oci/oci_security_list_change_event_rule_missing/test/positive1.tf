provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_core_security_list" "test_sl" {
  compartment_id = "ocid1.compartment.oc1..aaaa"
  vcn_id         = "ocid1.vcn.oc1..aaaa"
  display_name   = "vulnerable_sl"
}