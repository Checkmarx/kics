provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "correct_user_rule" {
  display_name   = "CorrectUserRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

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
      is_enabled  = true
    }
  }
}