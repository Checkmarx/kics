resource "alicloud_actiontrail_trail" "actiontrail1" {

}

resource "alicloud_ram_account_password_policy" "corporate" {  
  rds_database_migration_user_password = "pass"
  rds_database_rw_user_password = "pass"
  minimum_password_length      = 9
  rds_database_ro_user_password = "pass"
}
