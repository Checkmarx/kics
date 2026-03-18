provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "incomplete_user_rule" {
  display_name   = "IncompleteUserRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  # FALLO: Faltan enableuser y disableuser
  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identity.createuser",
      "com.oraclecloud.identity.updateuser",
      "com.oraclecloud.identity.deleteuser"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }
}