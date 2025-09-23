module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name_prefix = "negative9"
  path        = "/"
  description = "My example policy"

  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "ssm:GetParameter"
          ],
          "Effect": "Deny",
          "Resource": "*"
        }
      ]
    }
  EOF
}