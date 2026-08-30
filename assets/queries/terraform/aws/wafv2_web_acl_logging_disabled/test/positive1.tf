resource "aws_wafv2_web_acl" "fail" {
  name  = "my-waf-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "my-waf-metric"
    sampled_requests_enabled   = true
  }
}
