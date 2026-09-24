# These SHOULD be flagged - non-public buckets allowing public policies

# Regular application bucket (not website/CDN)
resource "aws_s3_bucket" "app_data" {
  bucket = "application-data-bucket"
}

resource "aws_s3_bucket_public_access_block" "app_data_public" {
  bucket = aws_s3_bucket.app_data.id
  block_public_policy = false  # Should be flagged - not a public use case
}

# Database backup bucket
resource "aws_s3_bucket" "db_backups" {
  bucket = "database-backup-storage"
}

resource "aws_s3_account_public_access_block" "account_level" {
  block_public_policy = false  # Should be flagged - allows public policies
}
