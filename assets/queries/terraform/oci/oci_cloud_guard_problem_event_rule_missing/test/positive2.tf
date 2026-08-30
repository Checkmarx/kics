provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "cg_disabled" {
  display_name = "CloudGuardDisabled"
  is_enabled   = false
  condition    = "{\"eventType\":[\"com.oraclecloud.cloudguard.problem\"]}"

  actions {
    actions {
      action_type = "ONS"
      is_enabled  = true
      topic_id    = "ocid1.onstopic..."
    }
  }
}