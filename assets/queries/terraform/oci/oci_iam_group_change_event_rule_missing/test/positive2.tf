provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "incomplete_rule" {
  display_name = "IncompleteRule"
  is_enabled   = true
  
  # Solo monitorea creación, faltan update y delete
  condition = <<EOT
    {"eventType": ["com.oraclecloud.identity.creategroup"]}
  EOT

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }
}