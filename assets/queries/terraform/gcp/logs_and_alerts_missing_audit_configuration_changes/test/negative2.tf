resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter      = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
}

resource "google_monitoring_alert_policy" "audit_config_alert" {
  display_name = "Audit Config Change Alert (Log Match)"

  combiner = "OR"

  conditions {
    display_name = "Audit Config Change Condition"              # test for unusual spacing
    condition_matched_log {
      filter = <<-FILTER
      protoPayload.methodName =  "SetIamPolicy"
            AND  protoPayload.serviceData.policyDelta.auditConfigDeltas : *
        FILTER
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}
