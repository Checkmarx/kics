provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "correct_rt_rule" {
  display_name   = "CorrectRTRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

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
      is_enabled  = true
    }
  }
}