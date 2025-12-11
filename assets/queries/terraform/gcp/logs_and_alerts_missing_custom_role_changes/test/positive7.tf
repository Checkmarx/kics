resource "google_logging_metric" "audit_config_change" {
  name        = "audit_config_change"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type="iam_role"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
    protoPayload.methodName="google.iam.admin.v1.UpdateRole" OR
    protoPayload.methodName="google.iam.admin.v1.UndeleteRole")
    AND protoPayload.serviceData.policyDelta.bindingDeltas.role="roles/editor")
  FILTER
} # specific filter has additional condition at the end
