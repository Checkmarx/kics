resource "google_logging_metric" "audit_config_change" {    # checks that extra OR statement is allowed 1
  name        = "audit_config_change_1"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type="iam_role"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
    NOT protoPayload.methodName="google.iam.admin.v1.UpdateRole" OR
    protoPayload.methodName="google.iam.admin.v1.UndeleteRole" OR
    protoPayload.methodName="any_other_value")
  FILTER
}