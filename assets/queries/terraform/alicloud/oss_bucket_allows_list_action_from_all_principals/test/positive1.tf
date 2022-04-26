resource "alicloud_oss_bucket" "bucket-policy3" {
  bucket = "bucket-3-policy"
  acl    = "private"

  policy = <<POLICY
  {"Statement": [
    {
        "Action": [
            "oss:ListObjectVersions", "oss:ListObjects", "oss:ListParts"
        ],
        "Effect": "Allow",
        "Principal": [
            "*"
        ],
        "Resource": [
            "acs:oss:*:174649585760xxxx:examplebucket"
        ]
    }
  ],
   "Version":"1"}
  POLICY
}
