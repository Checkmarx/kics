resource "oci_logging_log" "wrong_service_log" {
  display_name = "wrong_service"
  log_group_id = "ocid1.loggroup.oc1..cccc"
  log_type     = "SERVICE"
  is_enabled   = true

  configuration {
    source {
      resource = "ocid1.subnet.oc1..aaaa"
      # FALLO: Debería ser flowlogs
      service  = "wronglogs"
    }
  }
}