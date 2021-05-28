provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "secure_policy" {
  description             = "KMS key + secure_policy"
  deletion_window_in_days = 7

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Secure Policy",
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
            ],
            "Principal": "AWS": [
              "arn:aws:iam::AWS-account-ID:user/user-name-1",
              "arn:aws:iam::AWS-account-ID:user/UserName2"
            ]
        }
    ]
}
EOF
}
