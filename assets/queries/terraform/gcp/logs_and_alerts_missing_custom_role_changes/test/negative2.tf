resource "google_logging_metric" "logging_metric" {
  name   = "custom-role-changes-metric"
  filter = <<-FILTER
    resource.type="project"
    protoPayload.serviceName="iam.googleapis.com"
    (
      protoPayload.methodName:*
      protoPayload.methodName =~ "(CreateRole|UpdateRole|DeleteRole|UndeleteRole)"
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
    display_name = "Custom Role Changes Metric"
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
