provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_nsg_rule" {
  display_name   = "DisabledNSGRule"
  compartment_id = "ocid1.tenancy..."
  description    = "Has all events but is disabled"

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
    }
  }

  is_enabled = false
}