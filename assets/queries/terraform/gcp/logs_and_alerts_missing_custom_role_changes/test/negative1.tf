resource "google_logging_metric" "logging_metric" {
  name   = "custom-role-changes-metric"
  filter = <<-FILTER
    resource.type="project"
    protoPayload.serviceName="iam.googleapis.com"
    (
      protoPayload.methodName:*
    )
  FILTER
}

resource "google_logging_metric" "logging_metric_2" {
  name   = "custom-role-changes-metric_2"
  filter = <<-FILTER
    resource.type="project"
    protoPayload.serviceName="iam.googleapis.com"
    (
      protoPayload.methodName:*
      protoPayload.methodName =~ "(CreateRole|UpdateRole|DeleteRole|UndeleteRole)"
    )
  FILTER
}
