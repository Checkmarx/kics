provider "aws" {
  region = "us-east-2"
}

resource "aws_cloudwatch_log_group" "CloudWatch_LogsGroup" {
  name = "CloudWatch_LogsGroup"
}

resource "aws_sns_topic" "alerts_sns_topic" {
  name = "alerts-sns-topic"
}

resource "aws_cloudwatch_metric_alarm" "iam_policy_change" {
  alarm_name                = "IAM-Policy-Change"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.iam_policy_change.id
  namespace                 = "Metric_Alarm_Namespace"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.alerts_sns_topic.arn]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "iam_policy_change" {
  name           = "IAM-Policy-Change"
  pattern        = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
  log_group_name = aws_cloudwatch_log_group.CloudWatch_LogsGroup.name

  metric_transformation {
    name      = "IAM-Policy-Change"
    namespace = "Metric_Alarm_Namespace"
    value     = "1"
  }
}
