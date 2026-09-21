resource "google_logging_metric" "audit_config_change_1" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter      = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
}

resource "google_logging_metric" "audit_config_change_2" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter      = "protoPayload.serviceData.policyDelta.auditConfigDeltas:* AND protoPayload.methodName=\"SetIamPolicy\""
}