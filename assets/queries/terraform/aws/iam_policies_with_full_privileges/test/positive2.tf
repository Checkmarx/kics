module "SSO_permissionset" {
  source = "../../..//modules/permissionset"

  permission_set_name        = "SSO-permissionset1"
  inline_policy_to_attach    = local.sso_permissionset_policy
}

# define the inline policy for SSO permission set
locals {
  sso_permissionset_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_ssoadmin_permission_set" "permission_set" {
  name             = var.permission_set_name
  description      = var.permission_set_description
  instance_arn     = var.awssso_arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline_policy" {
  inline_policy      = var.inline_policy_to_attach
  instance_arn       = var.awssso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
}
