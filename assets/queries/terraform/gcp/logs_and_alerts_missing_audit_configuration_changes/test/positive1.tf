resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter      = "protoPayload.methodName=\"wrong_method\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
  # incorrect filter
}

resource "google_monitoring_alert_policy" "audit_config_alert" {
  display_name = "Audit Config Change Alert"

  combiner = "OR"

  conditions {
    display_name = "Audit Config Change Condition"
    condition_threshold {
      filter = "resource.type=\"gce_instance\" AND metric.type=\"logging.googleapis.com/user/audit_config_change\""
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}
