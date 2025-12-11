resource "google_monitoring_alert_policy" "audit_config_alert" {
  display_name = "Audit Config Change Alert"

  combiner = "OR"

  conditions {
    display_name = "Audit Config Change Condition"
    condition_threshold {
      filter = "resource.type=\"gce_instance\" AND metric.type=\"logging.googleapis.com/user/audit_config_change\""
    } # missing specific filter
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}
