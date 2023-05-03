provider "aws" {
  region = "us-east-2"
}

resource "aws_cloudwatch_log_group" "CloudWatch_LogsGroup" {
  name = "CloudWatch_LogsGroup"
}

resource "aws_sns_topic" "alerts_sns_topic" {
  name = "alerts-sns-topic"
}

resource "aws_cloudwatch_metric_alarm" "disable_delete_cmk" {
  alarm_name                = "Disable-Scheduled-Delete-CMK"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.disable_delete_cmk.id
  namespace                 = "Metric_Alarm_Namespace"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.alerts_sns_topic.arn]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "disable_delete_cmk" {
  name           = "Disable-Scheduled-Delete-CMK"
  pattern        = "{ ($.eventSource = \"kms.amazonaws.com\") || (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
  log_group_name = aws_cloudwatch_log_group.CloudWatch_LogsGroup.name

  metric_transformation {
    name      = "Disable-Scheduled-Delete-CMK"
    namespace = "Metric_Alarm_Namespace"
    value     = "1"
  }
}
