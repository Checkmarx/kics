module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name_prefix = "negative8"
  path        = "/"
  description = "My example policy"

  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "safe_array_action"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
  EOF
}