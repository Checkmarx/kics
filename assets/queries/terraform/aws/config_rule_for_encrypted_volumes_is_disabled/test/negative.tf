resource "aws_config_config_rule" "negative1" {
  name = "encrypted_vols_rule"

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }
}

resource "aws_config_config_rule" "negative2" {
  name = "another_rule"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
}