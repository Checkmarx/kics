provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_rule" {
  display_name = "DisabledRule"
  # FALLO: Deshabilitada
  is_enabled   = false
  
  condition = <<EOT
    {"eventType": [
      "com.oraclecloud.identity.creategroup",
      "com.oraclecloud.identity.updategroup",
      "com.oraclecloud.identity.deletegroup"
    ]}
  EOT

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }
}