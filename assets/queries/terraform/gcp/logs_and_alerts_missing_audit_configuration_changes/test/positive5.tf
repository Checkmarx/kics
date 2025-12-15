resource "google_monitoring_alert_policy" "audit_config_alert" {
  display_name = "Audit Config Change Alert (Log Match)"

  combiner = "OR"

  conditions {
    display_name = "Audit Config Change Condition"              # test for unusual spacing
    condition_matched_log {
      filter = <<-FILTER
      protoPayload.methodName =  "SetIamPolicy"
            AND  protoPayload.serviceData.policyDelta.auditConfigDeltas : *
        FILTER
    }
  }

  # missing notification channels
}
