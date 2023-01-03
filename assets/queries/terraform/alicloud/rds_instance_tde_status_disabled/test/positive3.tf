resource "alicloud_db_instance" "default" {
    engine = "SQLServer"
    engine_version = "2019_std_ha"
    db_instance_class = "rds.mysql.t1.small"
    db_instance_storage = "10"
    tde_status = "Disabled"
    parameters = []
}
