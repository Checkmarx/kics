provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "correct_idp_rule" {
  display_name   = "CorrectIdPRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identitycontrolplane.updateidentityprovider"
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