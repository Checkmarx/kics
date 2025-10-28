resource "google_logging_metric" "logging_metric" {
  name   = "my-(custom)/metric"

  # filter negates the "DeleteRole" method
  filter = <<-FILTER
        resource.type="iam_role"
        AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
        NOT protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
        protoPayload.methodName="google.iam.admin.v1.UpdateRole OR
        protoPayload.methodName="google.iam.admin.v1.UndeleteRole")
      FILTER
}

resource "google_logging_metric" "logging_metric_2" {
  name   = "my-(custom)/metric_2"

  # filter for the wrong resource type
  filter = <<-FILTER
        resource.type="not_iam_role"
        AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
        protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
        protoPayload.methodName="google.iam.admin.v1.UpdateRole OR
        protoPayload.methodName="google.iam.admin.v1.UndeleteRole")
      FILTER
}
