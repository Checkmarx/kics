provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_vcn_rule" {
  display_name   = "DisabledVCNRule"
  compartment_id = "ocid1.tenancy.oc1..aaaa"

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createvcn",
      "com.oraclecloud.virtualnetwork.updatevcn",
      "com.oraclecloud.virtualnetwork.deletevcn"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic.oc1..aaaa"
    }
  }

  is_enabled = false
}