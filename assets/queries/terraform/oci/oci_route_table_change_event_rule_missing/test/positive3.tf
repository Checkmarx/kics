provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_rt_rule" {
  display_name   = "DisabledRTRule"
  compartment_id = "ocid1.tenancy..."
  description    = "Has all events but is disabled"

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createroutetable",
      "com.oraclecloud.virtualnetwork.updateroutetable",
      "com.oraclecloud.virtualnetwork.deleteroutetable"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }

  is_enabled = false
}