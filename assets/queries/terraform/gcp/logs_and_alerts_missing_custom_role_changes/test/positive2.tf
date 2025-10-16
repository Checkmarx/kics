resource "google_monitoring_alert_policy" "custom_role_changes" {
  display_name = "Custom Role Changes Alert"
  combiner     = "OR"

  conditions {
    display_name = "Detect Create/Update/Delete Role Audit Logs"

    condition_matched_log {

      # filter does not include the "UpdateRole" method
      filter = <<-FILTER
        resource.type="project"
        protoPayload.serviceName="iam.googleapis.com"
        protoPayload.methodName =~ "(CreateRole|DeleteRole|UndeleteRole)"
      FILTER

      label_extractors = {
        "method"    = "EXTRACT(protoPayload.methodName)"
        "principal" = "EXTRACT(protoPayload.authenticationInfo.principalEmail)"
        "project"   = "EXTRACT(resource.labels.project_id)"
      }

      duration = "60s"
    }
  }

  notification_channels = []
  user_labels = {
    "purpose" = "detect-custom-role-changes"
  }
}
