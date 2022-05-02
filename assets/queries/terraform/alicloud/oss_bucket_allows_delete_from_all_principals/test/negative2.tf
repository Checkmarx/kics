resource "alicloud_oss_bucket" "bucket-policy3" {
  bucket = "bucket-3-policy"
  acl    = "private"

  policy = <<POLICY
  {"Statement": [
    {
        "Action": [
            "oss:PutObject", "oss:DeleteBucket"
        ],
        "Effect": "Allow",
        "Principal": [
            "20214760404935xxxx"
        ],
        "Resource": [
            "acs:oss:*:174649585760xxxx:examplebucket"
        ]
    }
  ],
   "Version":"1"}
  POLICY
}
