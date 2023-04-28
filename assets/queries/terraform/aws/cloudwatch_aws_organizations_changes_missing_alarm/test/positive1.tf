provider "aws" {
  region = "us-east-2"
}

resource "aws_cloudwatch_log_group" "CloudWatch_LogsGroup" {
  name = "CloudWatch_LogsGroup"
}

resource "aws_sns_topic" "alerts_sns_topic" {
  name = "alerts-sns-topic"
}

resource "aws_cloudwatch_metric_alarm" "aws_organizations" {
  alarm_name                = "AWS-Organizations"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "OTHER FILTER"
  namespace                 = "Metric_Alarm_Namespace"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_actions             = [aws_sns_topic.alerts_sns_topic.arn]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "aws_organizations" {
  name           = "AWS-Organizations"
  pattern        = "{ ($.eventSource = \"organizations.amazonaws.com\") && (($.eventName = \"AcceptHandshake\") || ($.eventName = 'AttachPolicy') || ($.eventName = CreateAccount) || ($.eventName = PutBucketLifecycle) || ($.eventName = CreateOrganizationalUnit) || ($.eventName = CreatePolicy) || ($.eventName = DeclineHandshake) || ($.eventName = DeleteOrganization) || ($.eventName = DeleteOrganizationalUnit) || ($.eventName = DeletePolicy) || ($.eventName = DetachPolicy) || ($.eventName = DisablePolicyType) || ($.eventName = EnablePolicyType) || ($.eventName = InviteAccountToOrganization) || ($.eventName = LeaveOrganization) || ($.eventName = MoveAccount) || ($.eventName = RemoveAccountFromOrganization) || ($.eventName = UpdatePolicy) || ($.eventName = UpdateOrganizationalUni)) }"
  log_group_name = aws_cloudwatch_log_group.CloudWatch_LogsGroup.name

  metric_transformation {
    name      = "AWS-Organizations"
    namespace = "Metric_Alarm_Namespace"
    value     = "1"
  }
}
