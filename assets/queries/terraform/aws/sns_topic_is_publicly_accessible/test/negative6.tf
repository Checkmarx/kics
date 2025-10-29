module "sns_topic_with_policy_statements" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 6.0"

  name = "example-sns-topic-statements"

  topic_policy_statements = [
    {
      sid     = "AllowVPCEAccess"
      effect  = "Allow"
      actions = ["sns:Publish"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["*"]
        }
      ]
      condition = {
        StringEquals = {
          "aws:VpceAccount" = "987654321098"
        }
      }
    }
  ]
}
