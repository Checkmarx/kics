resource "oci_core_subnet" "secure_subnet" {
  cidr_block     = "10.0.1.0/24"
  compartment_id = "ocid1.compartment.oc1..aaaa"
  vcn_id         = "ocid1.vcn.oc1..bbbb"
  display_name   = "secure_subnet"
}

resource "oci_logging_log" "secure_flow_log" {
  display_name = "secure_log"
  log_group_id = "ocid1.loggroup.oc1..cccc"
  log_type     = "SERVICE"
  is_enabled   = true

  configuration {
    source {
      resource = oci_core_subnet.secure_subnet.id
      service  = "flowlogs"
      category = "all"
    }
  }
}