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
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "DISTRIBUTION"
    unit        = "1"
    labels {
      key         = "mass"
      value_type  = "STRING"
      description = "amount of matter"
    }
    labels {
      key         = "sku"
      value_type  = "INT64"
      description = "Identifying number for item"
    }
    display_name = "My metric"
  }
  value_extractor = "EXTRACT(jsonPayload.request)"
  label_extractors = {
    "mass" = "EXTRACT(jsonPayload.request)"
    "sku"  = "EXTRACT(jsonPayload.id)"
  }
  bucket_options {
    linear_buckets {
      num_finite_buckets = 3
      width              = 1
      offset             = 1
    }
  }
}
