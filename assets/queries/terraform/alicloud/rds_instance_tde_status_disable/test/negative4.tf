resource "alicloud_db_instance" "default" {
    engine = "SQLServer"
    engine_version = "2016_ent_ha"
    db_instance_class = "rds.mysql.t1.small"
    db_instance_storage = "10"
    tde_status = "Enabled"
    parameters = []
}
