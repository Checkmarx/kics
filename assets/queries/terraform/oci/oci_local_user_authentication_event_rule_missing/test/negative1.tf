provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "correct_auth_rule" {
  display_name   = "CorrectAuthRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identity.localuser.authenticate"
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