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
  # missing notification channels
}
