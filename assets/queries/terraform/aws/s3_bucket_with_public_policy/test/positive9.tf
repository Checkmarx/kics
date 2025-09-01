resource "aws_s3_account_public_access_block" "allow_public_acc" {
  block_public_policy = false /* insecure - explicitly unsafe value */
}