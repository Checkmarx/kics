resource "google_logging_metric" "logging_metric" {
  name   = "custom-role-changes-metric"
  filter = <<-FILTER
        protoPayload.methodName="SetIamPolicy" AND
        protoPayload.serviceData.policyDelta.auditConfigDeltas:*
  FILTER
}
