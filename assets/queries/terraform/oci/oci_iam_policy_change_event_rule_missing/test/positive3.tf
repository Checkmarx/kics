provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_rule" {
  display_name   = "DisabledPolicyRule"
  compartment_id = "ocid1.tenancy.oc1.."
  description    = "Rule with all events but disabled"

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
    }
  }

  is_enabled = false
}