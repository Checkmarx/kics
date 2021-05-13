resource "aws_neptune_cluster" "postive2" {
  cluster_identifier                  = "neptune-cluster"
  engine                              = "neptune"
  backup_retention_period             = 5
  preferred_backup_window             = "10:10-11:11"
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  apply_immediately                   = true
  enable_cloudwatch_logs_exports      = []
}
