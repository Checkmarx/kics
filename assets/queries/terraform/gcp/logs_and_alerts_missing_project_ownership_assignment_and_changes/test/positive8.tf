resource "google_logging_metric" "positive8" {
  name        = "project_ownership_with_not"
  description = "Invalid filter - has NOT before one of the conditions"
  filter = <<-FILTER
    (protoPayload.serviceName="cloudresourcemanager.googleapis.com")
    AND NOT (ProjectOwnership OR projectOwnerInvitee)
    OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="REMOVE"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
    OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="ADD"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
  FILTER
  # incorrect filter - has NOT before (ProjectOwnership OR projectOwnerInvitee)
}

