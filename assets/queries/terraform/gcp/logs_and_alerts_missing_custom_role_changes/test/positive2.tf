resource "google_monitoring_alert_policy" "custom_role_changes" {
  display_name = "Custom Role Changes Alert"

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

    }
  }
}

resource "google_monitoring_alert_policy" "custom_role_changes_2" {
  display_name = "Custom Role Changes Alert 2"

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
          protoPayload.methodName="google.iam.admin.v1.UpdateRole"
          protoPayload.methodName="google.iam.admin.v1.DeleteRole"
          protoPayload.methodName="google.iam.admin.v1.UndeleteRole"
          protoPayload.methodName="projects.someProject.locations.someLocation.AnyotherMethod"
        )
      FILTER
    }
  }
}

resource "google_monitoring_alert_policy" "custom_role_changes_3" {
  display_name = "Custom Role Changes Alert 3"

  conditions {
    display_name = "Detect Create/Update/Delete Role Audit Logs"

    condition_matched_log {

      # Inequality (!=) statement
      filter = <<-FILTER
        resource.type="project"
        protoPayload.serviceName="iam.googleapis.com"
        protoPayload.methodName:*
        (
          protoPayload.methodName="google.iam.admin.v1.CreateRole"
          OR protoPayload.methodName!="google.iam.admin.v1.UpdateRole"
          OR protoPayload.methodName="google.iam.admin.v1.DeleteRole"
          OR protoPayload.methodName="google.iam.admin.v1.UndeleteRole"
          OR protoPayload.methodName="projects.someProject.locations.someLocation.AnyotherMethod"
        )
      FILTER
    }
  }
}
