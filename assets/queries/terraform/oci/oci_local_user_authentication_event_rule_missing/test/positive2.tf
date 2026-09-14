provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_auth_rule" {
  display_name   = "DisabledAuthRule"
  compartment_id = "ocid1.tenancy..."
  description    = "Monitors Auth but is disabled"

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identity.localuser.authenticate"
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