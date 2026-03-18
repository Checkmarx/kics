provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_user_rule" {
  display_name   = "DisabledUserRule"
  compartment_id = "ocid1.tenancy..."
  description    = "Has all events but is disabled"

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identity.createuser",
      "com.oraclecloud.identity.updateuser",
      "com.oraclecloud.identity.deleteuser",
      "com.oraclecloud.identity.enableuser",
      "com.oraclecloud.identity.disableuser"
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