resource "oci_core_subnet" "subnet_without_log" {
  cidr_block     = "10.0.1.0/24"
  compartment_id = "ocid1.compartment.oc1..aaaa"
  vcn_id         = "ocid1.vcn.oc1..bbbb"
  display_name   = "orphan_subnet"
}