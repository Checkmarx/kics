resource "aws_kms_key" "positive4" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

resource "aws_kms_key_policy" "positive4" {
  key_id = aws_kms_key.positive4.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement":[
      {
        "Sid":"AddCannedAcl",
        "Effect":"Allow",
        "Principal": {"AWS":"*"},
        "Action":["kms:*"],
        "Resource":"*"
      }
    ]
  }
  POLICY
}