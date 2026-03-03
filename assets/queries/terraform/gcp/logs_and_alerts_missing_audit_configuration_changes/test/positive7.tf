resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter      = "protoPayload.methodName=\"wrong_method\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
  # incorrect filter
}
