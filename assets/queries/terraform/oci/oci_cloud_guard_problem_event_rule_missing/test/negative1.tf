provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "cg_correct" {
  display_name = "CloudGuardCorrect"
  is_enabled   = true
  condition    = "{\"eventType\":[\"com.oraclecloud.cloudguard.problem\"]}"

  actions {
    actions {
      action_type = "ONS"
      is_enabled  = true
      topic_id    = "ocid1.onstopic..."
    }
  }
}