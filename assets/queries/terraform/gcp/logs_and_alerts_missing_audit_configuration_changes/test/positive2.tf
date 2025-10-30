resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter      = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
}

# missing a "google_monitoring_alert_policy" resource
