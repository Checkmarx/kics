provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_events_rule" "bucket_event" {
  display_name = "BucketEvent"
  is_enabled   = true
  condition    = "{\"eventType\":[\"com.oraclecloud.objectstorage.createbucket\"]}"

  actions {
    actions {
      action_type = "ONS"
      is_enabled  = true
      topic_id    = "ocid1.onstopic..."
    }
  }
}