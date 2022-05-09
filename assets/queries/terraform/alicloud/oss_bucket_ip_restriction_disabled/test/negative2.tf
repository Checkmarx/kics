resource "alicloud_oss_bucket" "bucket-securetransport2"{
        policy = <<POLICY
{
        "Version": "1",
        "Statement": 
        [
            {
                "Effect": "Deny",
                "Action": 
                [
                    "oss:RestoreObject",
                    "oss:ListObjects",
                    "oss:AbortMultipartUpload",
                    "oss:PutObjectAcl",
                    "oss:GetObjectAcl",
                    "oss:ListParts",
                    "oss:DeleteObject",
                    "oss:PutObject",
                    "oss:GetObject",
                    "oss:GetVodPlaylist",
                    "oss:PostVodPlaylist",
                    "oss:PublishRtmpStream",
                    "oss:ListObjectVersions",
                    "oss:GetObjectVersion",
                    "oss:GetObjectVersionAcl",
                    "oss:RestoreObjectVersion"
                ],
                "Principal": 
                [
                    "*"
                ],
                "Resource": 
                [
                    "acs:oss:*:0000111122223334:af/*"
                ],
                "Condition": 
                {
                    "NotIpAdress": 
                    {
                        "acs:SourceIp": "10.0.0.0"
                    }
                }
            }
        ]
}
POLICY

}
