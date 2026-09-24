provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "correct_rule" {
  display_name   = "CorrectPolicyRule"
  compartment_id = "ocid1.tenancy.oc1.."
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identity.createpolicy",
      "com.oraclecloud.identity.updatepolicy",
      "com.oraclecloud.identity.deletepolicy"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic.oc1.."
      is_enabled  = true
    }
  }
}