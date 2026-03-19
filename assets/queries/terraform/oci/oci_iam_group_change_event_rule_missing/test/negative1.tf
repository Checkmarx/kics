provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "iam_group_changes" {
  display_name = "IAMGroupChanges"
  is_enabled   = true
  
  condition = <<EOT
    {"eventType": [
      "com.oraclecloud.identity.creategroup",
      "com.oraclecloud.identity.updategroup",
      "com.oraclecloud.identity.deletegroup"
    ]}
  EOT

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }
}