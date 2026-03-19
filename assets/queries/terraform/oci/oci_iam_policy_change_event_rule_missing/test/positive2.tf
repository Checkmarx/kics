provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "incomplete_rule" {
  display_name   = "IncompletePolicyRule"
  compartment_id = "ocid1.tenancy.oc1.."
  is_enabled     = true

  # FALLO: Falta "deletepolicy"
  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identity.createpolicy",
      "com.oraclecloud.identity.updatepolicy"
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