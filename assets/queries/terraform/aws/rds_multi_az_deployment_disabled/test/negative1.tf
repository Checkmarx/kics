resource "aws_db_instance" "test-replica" {
  replicate_source_db         = aws_db_instance.default.identifier
  replica_mode                = "mounted"
  auto_minor_version_upgrade  = false
  custom_iam_instance_profile = "AWSRDSCustomInstanceProfile"
  backup_retention_period     = 7
  identifier                  = "ee-instance-replica"
  instance_class              = data.aws_rds_orderable_db_instance.custom-oracle.instance_class
  kms_key_id                  = data.aws_kms_key.by_id.arn
  multi_az                    = true
  skip_final_snapshot         = true
  storage_encrypted           = true

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}