resource "azurerm_postgresql_server" "postgre_server" {
    name                = "dbserver"
    location            = "usgovvirginia"
    resource_group_name = "${azurerm_resource_group.jira_rg.name}"

    sku {
        name     = "${var.jira_postgre_sku_name}"
        capacity = "${var.jira_postgre_sku_capacity}"
        tier     = "${var.jira_postgre_sku_tier}"
        family   = "${var.jira_postgre_sku_family}"
    }

    storage_profile {
        storage_mb            = "${var.jira_postgre_storage}"
        backup_retention_days = "${var.jira_postgre_data_retention}"
        geo_redundant_backup  = "Enabled"
        auto_grow             = "Enabled"
    }

    administrator_login          = "${var.mp_db_username}"
    administrator_login_password = "${azurerm_key_vault_secret.db_pswd.value}"
    version                      = "9.5"
    ssl_enforcement              = "Enabled"

    tags                         = "${local.postgresqlserver_tags}"
}
