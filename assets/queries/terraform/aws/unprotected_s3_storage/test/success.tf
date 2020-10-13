data "aws_canonical_user_id" "current_user" {}

resource "aws_s3_bucket" "bucket" {
  bucket = "mybucket"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "TEST"
      }
    }
  }

  grant {
    id          = data.aws_canonical_user_id.current_user.id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  grant {
    type        = "Group"
    permissions = ["READ", "WRITE"]
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }
}