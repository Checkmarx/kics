provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "compliant_sl_rule" {
  display_name   = "CompliantSLRule"
  compartment_id = "ocid1.tenancy.oc1..aaaa"
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.createsecuritylist",
      "com.oraclecloud.virtualnetwork.updatesecuritylist",
      "com.oraclecloud.virtualnetwork.deletesecuritylist"
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic.oc1..aaaa"
    }
  }
}