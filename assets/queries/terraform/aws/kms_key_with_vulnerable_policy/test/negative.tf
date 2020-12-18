resource "aws_kms_key" "a" {
  description             = "KMS key 1"
  deletion_window_in_days = 10

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement":[
      {
        "Sid":"AddCannedAcl",
        "Effect":"Allow",
        "Principal": "*",
        "Action":["kms:*"],
        "Resource":"*"
      }
    ]
  }
  POLICY
}

resource "aws_kms_key" "a2" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}