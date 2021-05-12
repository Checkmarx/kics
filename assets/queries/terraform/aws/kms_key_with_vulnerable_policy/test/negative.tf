resource "aws_kms_key" "negative1" {
  description             = "KMS key 1"
  deletion_window_in_days = 10

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement":[
      {
        "Sid":"AddCannedAcl",
        "Effect":"Allow",
        "Principal": { "AWS": "123456789012" },
        "Action":["kms:*"],
        "Resource":"*"
      }
    ]
  }
  POLICY
}

resource "aws_kms_key" "negative2" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}
