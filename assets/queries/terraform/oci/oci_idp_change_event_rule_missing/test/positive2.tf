provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_idp_rule" {
  display_name   = "DisabledIdPRule"
  compartment_id = "ocid1.tenancy..."
  description    = "Monitors IdP but is disabled"

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identitycontrolplane.updateidentityprovider"
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