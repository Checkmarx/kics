provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "incomplete_nsg_rule" {
  display_name   = "IncompleteNSGRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  # FALLO: Falta "deletenetworksecuritygroup"
  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createnetworksecuritygroup",
      "com.oraclecloud.virtualnetwork.updatenetworksecuritygroup"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }
}