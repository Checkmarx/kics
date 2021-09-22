provider "aws" {
  region = "us-east-2"
}

resource "aws_cloudwatch_log_group" "CIS_CloudWatch_LogsGroup" {
  name = "CIS_CloudWatch_LogsGroup"
}

resource "aws_sns_topic" "cis_alerts_sns_topic" {
  name = "cis-alerts-sns-topic"
}

resource "aws_cloudwatch_metric_alarm" "cis_disable_delete_cmk" {
  alarm_name                = "CIS-4.7-Disable-Scheduled-Delete-CMK"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.cis_disable_delete_cmk.id
  namespace                 = "CIS_Metric_Alarm_Namespace"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.cis_alerts_sns_topic.arn]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "cis_disable_delete_cmk" {
  name           = "CIS-4.7-Disable-Scheduled-Delete-CMK"
  pattern        = "{ ($.eventSource = \"kms.amazonaws.com\") && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
  log_group_name = aws_cloudwatch_log_group.CIS_CloudWatch_LogsGroup.name

  metric_transformation {
    name      = "CIS-4.7-Disable-Scheduled-Delete-CMK"
    namespace = "CIS_Metric_Alarm_Namespace"
    value     = "1"
  }
}
