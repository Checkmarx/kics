resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter      = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:* AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/editor\")"
} # specific filter has additional condition at the end
