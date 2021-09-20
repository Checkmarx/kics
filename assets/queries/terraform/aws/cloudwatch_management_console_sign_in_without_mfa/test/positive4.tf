resource "aws_cloudwatch_log_metric_filter" "CIS_No_MFA_Console_Signin_Metric_Filter" {
  name           = "CIS-ConsoleSigninWithoutMFA"
  pattern        = "{ ($.eventName = \"ConsoleLogin\") || ($.additionalEventData.MFAUsed != \"Yes\") }"
  log_group_name = "${aws_cloudwatch_log_group.CIS_CloudWatch_LogsGroup.name}"

  metric_transformation {
    name      = "CIS-ConsoleSigninWithoutMFA"
    namespace = "${var.CIS_Metric_Alarm_Namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "CIS_No_MFA_Console_Signin_CW_Alarm" {
  alarm_name                = "CIS-3.2-ConsoleSigninWithoutMFA"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.CIS_No_MFA_Console_Signin_Metric_Filter.id}"
  namespace                 = "${var.CIS_Metric_Alarm_Namespace}"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring for single-factor console logins will increase visibility into accounts that are not protected by MFA."
  alarm_actions             = ["${aws_sns_topic.CIS_Alerts_SNS_Topic.arn}"]
  insufficient_data_actions = []
}
