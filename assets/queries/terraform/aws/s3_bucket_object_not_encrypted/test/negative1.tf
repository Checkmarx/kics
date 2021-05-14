resource "aws_s3_bucket" "examplebucket" {
  bucket = "examplebuckettftest"
  acl    = "private"

  versioning {
    enabled = true
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
}

resource "aws_s3_bucket_object" "examplebucket_object" {
  key                    = "someobject"
  bucket                 = aws_s3_bucket.examplebucket.id
  source                 = "index.html"
  server_side_encryption = "AES256"
}
