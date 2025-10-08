module "sns_topic_with_policy_statements_valid" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 6.0"

  name = "example-sns-topic-statements-valid"

  topic_policy_statements = [
    {
      sid     = "AllowSpecificPrincipal"
      effect  = "Allow"
      actions = ["sns:Publish"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::123456789012:root"]
        }
      ]
    }
  ]
}
