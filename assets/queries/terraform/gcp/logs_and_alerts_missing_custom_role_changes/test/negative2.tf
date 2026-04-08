resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type="iam_role"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
    protoPayload.methodName="google.iam.admin.v1.UpdateRole" OR
    protoPayload.methodName="google.iam.admin.v1.UndeleteRole")
  FILTER
}

resource "google_monitoring_alert_policy" "audit_config_alert" {
  display_name = "Audit Config Change Alert (Log Match)"

  combiner = "OR"

  conditions {
    display_name = "Audit Config Change Condition"        # test for unusual spacing
    condition_matched_log {
      filter = <<-FILTER
        resource.type = "iam_role"
        AND ( protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR

        protoPayload.methodName  = "google.iam.admin.v1.DeleteRole"
        OR
        protoPayload.methodName =  "google.iam.admin.v1.UpdateRole"   OR
        protoPayload.methodName = "google.iam.admin.v1.UndeleteRole" )
      FILTER
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}
