resource "aws_cloudwatch_log_metric_filter" "network_gateway_changes_metric_filter" {
  name           = "NetworkGatewayChanges"
  pattern        = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DetachInternetGateway) }"
  log_group_name = aws_cloudwatch_log_group.CloudWatch_LogsGroup.name

  metric_transformation {
    name      = "NetworkGatewayChanges"
    namespace = "Metric_Alarm_Namespace"
    value     = "1"
  }
}
resource "aws_cloudwatch_metric_alarm" "network_gateway_changes_cw_alarm" {
  alarm_name                = "NetworkGatewayChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.network_gateway_changes_metric_filter.id
  namespace                 = "Metric_Alarm_Namespace"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to network gateways will help ensure that all ingress/egress traffic traverses the VPC border via a controlled path."
  alarm_actions             = [aws_sns_topic.Alerts_SNS_Topic.arn]
  insufficient_data_actions = []
}
