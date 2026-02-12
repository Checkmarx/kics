resource "google_logging_metric" "audit_config_change_1" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    (protoPayload.serviceName="cloudresourcemanager.googleapis.com")
    AND (ProjectOwnership OR projectOwnerInvitee)
    OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="REMOVE"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
    OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="ADD"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
  FILTER
}

resource "google_logging_metric" "audit_config_change_2" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    (protoPayload.serviceName="cloudresourcemanager.googleapis.com")
    AND (ProjectOwnership OR projectOwnerInvitee)
    OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="ADD"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
    OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="REMOVE"
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
  FILTER
}


resource "google_logging_metric" "audit_config_change_3" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
         ( protoPayload.serviceName  = "cloudresourcemanager.googleapis.com" )
        AND
         ( ProjectOwnership   OR projectOwnerInvitee  )
        OR   ( protoPayload.serviceData.policyDelta.bindingDeltas.action   =  "REMOVE"
        AND   protoPayload.serviceData.policyDelta.bindingDeltas.role  =   "roles/owner" )
        OR
         (
          protoPayload.serviceData.policyDelta.bindingDeltas.action =   "ADD" AND
            protoPayload.serviceData.policyDelta.bindingDeltas.role   = "roles/owner"
            )
      FILTER
}

resource "google_logging_metric" "audit_config_change_4" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
  (protoPayload.serviceName="cloudresourcemanager.googleapis.com")
  AND (ProjectOwnership OR projectOwnerInvitee)
  OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="REMOVE"
      AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
  OR (protoPayload.serviceData.policyDelta.bindingDeltas.action="ADD"
      AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/owner")
  OR (protoPayload.methodName="SetIamPolicy")
FILTER
}