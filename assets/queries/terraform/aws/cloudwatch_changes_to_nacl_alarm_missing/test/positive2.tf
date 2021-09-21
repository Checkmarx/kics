provider "aws" {
  region = "us-east-2"
}

resource "aws_cloudwatch_log_group" "CIS_CloudWatch_LogsGroup" {
  name = "CIS_CloudWatch_LogsGroup"
}

resource "aws_sns_topic" "cis_alerts_sns_topic" {
  name = "cis-alerts-sns-topic"
}

resource "aws_cloudwatch_metric_alarm" "cis_changes_nacl" {
  alarm_name                = "CIS-4.11-Changes-NACL"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.cis_changes_nacl.id
  namespace                 = "CIS_Metric_Alarm_Namespace"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.cis_alerts_sns_topic.arn]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "cis_changes_nacl" {
  name           = "CIS-4.11-Changes-NACL"
  pattern        = "{ ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
  log_group_name = aws_cloudwatch_log_group.CIS_CloudWatch_LogsGroup.name

  metric_transformation {
    name      = "CIS-4.11-Changes-NACL"
    namespace = "CIS_Metric_Alarm_Namespace"
    value     = "1"
  }
}
