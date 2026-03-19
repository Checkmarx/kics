provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "other_rule" {
  display_name   = "StorageRule"
  compartment_id = "ocid1.tenancy..."
  is_enabled     = true

  condition = jsonencode({
    "eventType": ["com.oraclecloud.objectstorage.createbucket"]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = "ocid1.onstopic..."
    }
  }
}