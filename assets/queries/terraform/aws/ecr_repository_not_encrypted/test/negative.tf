resource "aws_ecr_repository" "foo2" {
  name                 = "bar"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key = arn:aws:kms:region:account-id:key/key-id
  }
}
