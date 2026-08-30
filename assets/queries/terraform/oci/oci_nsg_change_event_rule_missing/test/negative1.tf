provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "correct_nsg_rule" {
  display_name   = "CorrectNSGRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createnetworksecuritygroup",
      "com.oraclecloud.virtualnetwork.updatenetworksecuritygroup",
      "com.oraclecloud.virtualnetwork.deletenetworksecuritygroup"
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