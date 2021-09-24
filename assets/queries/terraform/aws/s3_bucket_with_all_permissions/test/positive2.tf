module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket = "my-s3-bucket"
  acl    = "private"

  versioning = {
    enabled = true
  }

  policy = <<EOF
	{
	  "Id": "id113",
	  "Version": "2012-10-17",
	  "Statement": [
		{
		  "Action": [
			"s3:*"
		  ],
		  "Effect": "Allow",
		  "Resource": "arn:aws:s3:::S3B_181355/*",
		  "Principal": "*"
		}
	  ]
	}
  EOF
}
