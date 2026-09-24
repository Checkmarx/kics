provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "incomplete_vcn_rule" {
  display_name   = "IncompleteVCNRule"
  compartment_id = "ocid1.tenancy.oc1..aaaa"
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createvcn",
      "com.oraclecloud.virtualnetwork.updatevcn"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic.oc1..aaaa"
    }
  }
}