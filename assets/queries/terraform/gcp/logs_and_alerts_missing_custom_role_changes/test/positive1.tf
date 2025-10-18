resource "google_logging_metric" "logging_metric" {
  name   = "my-(custom)/metric"

  # filter negates the "DeleteRole" method
  filter = <<-FILTER
        resource.type="project"
        protoPayload.serviceName="iam.googleapis.com"
        (
          protoPayload.methodName =~ "(CreateRole|UpdateRole|DeleteRole|UndeleteRole)"
          AND NOT protoPayload.methodName:"DeleteRole"
        )
      FILTER
}

resource "google_logging_metric" "logging_metric_2" {
  name   = "my-(custom)/metric_2"

  # filter negates the "DeleteRole" method
  filter = <<-FILTER
        resource.type="project"
        protoPayload.serviceName="iam.googleapis.com"
        protoPayload.methodName =~ "(CreateRole|DeleteRole|UndeleteRole)"
      FILTER
}
