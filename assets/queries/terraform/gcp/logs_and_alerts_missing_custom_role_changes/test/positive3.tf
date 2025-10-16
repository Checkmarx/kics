resource "google_monitoring_alert_policy" "custom_role_changes" {
  display_name = "Custom Role Changes Alert"
  combiner     = "OR"

  conditions {
    display_name = "Detect Create/Update/Delete Role Audit Logs"

    condition_matched_log {

      # impossible filter, methodName cannot have all values simultaneosly
      filter = <<-FILTER
        resource.type="project"
        protoPayload.serviceName="iam.googleapis.com"
        protoPayload.methodName:*
        (
          protoPayload.methodName="google.iam.admin.v1.CreateRole"
          AND protoPayload.methodName="google.iam.admin.v1.UpdateRole"
          AND protoPayload.methodName="google.iam.admin.v1.DeleteRole"
          AND protoPayload.methodName="google.iam.admin.v1.UndeleteRole"
          AND protoPayload.methodName="projects.someProject.locations.someLocation.AnyotherMethod"
        )
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
