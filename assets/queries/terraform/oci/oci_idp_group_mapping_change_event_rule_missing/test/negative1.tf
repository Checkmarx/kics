provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "correct_mapping_rule" {
  display_name   = "CorrectMappingRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identitycontrolplane.updateidpgroupmapping"
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