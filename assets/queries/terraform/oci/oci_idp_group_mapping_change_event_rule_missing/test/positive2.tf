provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "disabled_mapping_rule" {
  display_name   = "DisabledMappingRule"
  compartment_id = "ocid1.tenancy..."
  description    = "Monitors IdP Mapping but is disabled"

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.identitycontrolplane.updateidpgroupmapping"
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