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
  FILTER
}

resource "google_monitoring_alert_policy" "audit_config_alert" {
  display_name = "Audit Config Change Alert (Log Match)"

  combiner = "OR"

  conditions {
    display_name = "Audit Config Change Condition"        # test for unusual spacing
    condition_matched_log {
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
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}
