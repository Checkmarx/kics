resource "google_logging_metric" "logging_metric" {
  name   = "custom-role-changes-metric"
  filter = <<-FILTER
    resource.type="iam_role"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
    protoPayload.methodName="google.iam.admin.v1.UpdateRole OR
    protoPayload.methodName="google.iam.admin.v1.UndeleteRole")
  FILTER
}
