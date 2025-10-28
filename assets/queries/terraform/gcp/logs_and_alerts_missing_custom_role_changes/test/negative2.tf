resource "google_monitoring_alert_policy" "custom_role_changes" {
  display_name = "Custom Role Changes Alert"

  conditions {
    display_name = "Detect Create/Update/Delete Role Audit Logs"

    condition_matched_log {
      filter = <<-FILTER
        resource.type="iam_role"
        AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
        protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
        protoPayload.methodName="google.iam.admin.v1.UpdateRole OR
        protoPayload.methodName="google.iam.admin.v1.UndeleteRole")
      FILTER
    }
  }
}

resource "google_monitoring_alert_policy" "custom_role_changes2" {
  display_name = "Custom Role Changes Alert"

  conditions {
    display_name = "Detect Create/Update/Delete Role Audit Logs"

    condition_matched_log {
      filter = <<-FILTER
        resource.type="iam_role"
        AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
        NOT protoPayload.methodName!="google.iam.admin.v1.DeleteRole" OR
        protoPayload.methodName="google.iam.admin.v1.UpdateRole OR
        protoPayload.methodName="google.iam.admin.v1.UndeleteRole")
      FILTER
    }
  }
}
