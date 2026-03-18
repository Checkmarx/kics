resource "oci_logging_log" "wrong_type_log" {
  display_name = "wrong_type"
  log_group_id = "ocid1.loggroup.oc1..cccc"
  
  # FALLO: Debería ser SERVICE
  log_type     = "CUSTOM"
  is_enabled   = true

  configuration {
    source {
      resource = "ocid1.subnet.oc1..aaaa"
      service  = "flowlogs"
    }
  }
}