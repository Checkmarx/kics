resource "aws_kms_key" "negative2" {
  description             = "KMS key 2"
  deletion_window_in_days = 10
}

resource "aws_kms_key_policy" "negative2" {
  key_id = aws_kms_key.negative2.id
  policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement":[
        {
          "Sid":"AddCannedAcl",
          "Effect":"Deny",
          "Principal": {"AWS": [
            "arn:aws:iam::111122223333:user/CMKUser"
          ]},
          "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ],
          "Resource":"*"
        }
      ]
    }
    POLICY
}
