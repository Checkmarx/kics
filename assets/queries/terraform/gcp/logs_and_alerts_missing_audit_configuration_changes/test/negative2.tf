resource "google_monitoring_alert_policy" "custom_role_changes" {
  display_name = "Custom Role Changes Alert"

  conditions {
    display_name = "Detect Create/Update/Delete Role Audit Logs"

    condition_matched_log {
      filter = <<-FILTER
        protoPayload.methodName = "SetIamPolicy"
        AND protoPayload.serviceData.policyDelta.auditConfigDeltas: *
      FILTER
    }
  }
}

resource "google_monitoring_alert_policy" "custom_role_changes2" {
  display_name = "Custom Role Changes Alert"

  conditions {
    display_name = "Detect Create/Update/Delete Role Audit Logs"

    condition_matched_log {             # varied spacing test 2
      filter = <<-FILTER
        protoPayload.methodName =  "SetIamPolicy"
            AND protoPayload.serviceData.policyDelta.auditConfigDeltas :  *
      FILTER
    }
  }
}
