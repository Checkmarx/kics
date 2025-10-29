resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter      = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
}

resource "google_monitoring_alert_policy" "audit_config_alert" {
  display_name = "Audit Config Change Alert"

  combiner = "OR"
  conditions {
    display_name = "Audit Config Change Condition"
    condition_threshold {
      filter = "resource.type=\"gce_instance\" AND metric.type=\"logging.googleapis.com/user/audit_config_change\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "0s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
      }
    }
  }

  notification_channel2s = [google_monitoring_notification_channel.email.id]
}
resource "google_monitoring_alert_policy" "audit_config_alert2" {
  display_name = "Audit Config Change Alert"

  combiner = "OR"
  conditions {
    display_name = "Audit Config Change Condition"
    condition_threshold {
      filter = "resource.type=\"gce_instance\" AND metric.type=\"logging.googleapis.com/use2r/audit_config_change\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "0s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}

resource "google_monitoring_alert_policy" "audit_config_alert3" {
  display_name = "Audit Config Change Alert"

  combiner = "OR"
  conditions {
    display_name = "Audit Config Change Condition"
    condition_threshold {
      filter = "resource.type=\"gce_instance\" AND metric.type=\"logging.googleapis.com/use2r/audit_config_change\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "0s"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "Security Team Email"
  type         = "email"
  labels = {
    email_address = "security-team@example.com"
  }
}
