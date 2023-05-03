resource "aws_cloudwatch_log_metric_filter" "s3_bucket_policy_change_metric_filter" {
  name           = "S3BucketPolicyChanges"
  pattern        = "{ ($.eventSource = \"s3.amazonaws.com\") && (($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"
  log_group_name = aws_cloudwatch_log_group.CloudWatch_LogsGroup.name

  metric_transformation {
    name      = "S3BucketPolicyChanges"
    namespace = "Metric_Alarm_Namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "S3_Bucket_Policy_Change_CW_Alarm" {
  alarm_name                = "S3BucketPolicyChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.s3_bucket_policy_change_metric_filter.id
  namespace                 = "Metric_Alarm_Namespace"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to S3 bucket policies may reduce time to detect and correct permissive policies on sensitive S3 buckets."
  alarm_actions             = [aws_sns_topic.Alerts_SNS_Topic.arn]
  insufficient_data_actions = []
}
