resource "aws_s3_account_public_access_block" "allow_public_acc" {
  // insecure - account resource block is defined, block_public_access is not set 
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "test-bucket-public-policy"
}

resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket                  = aws_s3_bucket.public_bucket.id
  /* insecure - bucket resource block is defined, block_public_access is not set */
}