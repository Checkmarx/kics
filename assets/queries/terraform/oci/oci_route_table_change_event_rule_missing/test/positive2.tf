provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "incomplete_rt_rule" {
  display_name   = "IncompleteRTRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  # FALLO: Falta "deleteroutetable"
  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createroutetable",
      "com.oraclecloud.virtualnetwork.updateroutetable"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }
}