data "aws_iam_policy_document" "glue-example-policy2" {
  statement {
    actions = [
      "glue:CreateTable",
    ]
    resources = ["arn:data.aws_partition.current.partition:glue:data.aws_region.current.name:data.aws_caller_identity.current.account_id:*"]
    principals {
      identifiers = ["arn:aws:iam::var.account_id:saml-provider/var.provider_name"]
      type        = "AWS"
    }
  }
}

resource "aws_glue_resource_policy" "example2" {
  policy = data.aws_iam_policy_document.glue-example-policy2.json
}
