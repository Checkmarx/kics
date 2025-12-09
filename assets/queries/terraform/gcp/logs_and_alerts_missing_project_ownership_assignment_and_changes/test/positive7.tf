resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    (protoPayload.serviceName="cloudresourcemanager.googleapis.com")
    AND (ProjectOwnership OR projectOwnerInvitee)
    OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="REMOVE"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
    OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="ADD"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
    AND (protoPayload.serviceData.policyDelta.bindingDeltas.action="ADD"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/editor")
  FILTER
} # specific filter has additional condition at the end
