resource "aws_elasticsearch_domain" "negativee" {
  domain_name           = "tf-test"
  elasticsearch_version = "2.3"
}

resource "aws_elasticsearch_domain_policy" "main8" {
  domain_name = aws_elasticsearch_domain.negativee.domain_name

  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal" : {
              "AWS": [
                "arn:aws:iam::123456789012:root",
                "arn:aws:iam::555555555555:root"
                ]
            },
            "Effect": "Allow",
            "Condition": {
                "IpAddress": {"aws:SourceIp": "127.0.0.1/32"}
            },
            "Resource": "${aws_elasticsearch_domain.negativee.arn}/*"
        }
    ]
}
POLICIES
}
