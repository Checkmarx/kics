resource "oci_logging_log" "disabled_flow_log" {
  display_name = "disabled_log"
  log_group_id = "ocid1.loggroup.oc1..cccc"
  log_type     = "SERVICE"
  
  # FALLO: Deshabilitado
  is_enabled   = false

  configuration {
    source {
      resource = "ocid1.subnet.oc1..aaaa"
      service  = "flowlogs"
    }
  }
}