
resource "azurerm_postgresql_server" "positive1" {
    name                = "dbserver"
    location            = "usgovvirginia"
    resource_group_name = azurerm_resource_group.jira_rg.name

    sku_name   = "GP_Gen5_4"
    version    = "9.6"
    storage_mb = 640000

    backup_retention_days        = var.jira_postgre_data_retention
    auto_grow_enabled            = true

    administrator_login          = var.mp_db_username
    administrator_login_password = azurerm_key_vault_secret.db_pswd.value
    ssl_enforcement_enabled      = true

    tags                         = local.postgresqlserver_tags
}

resource "azurerm_postgresql_server" "positive2" {
    name                = "dbserver"
    location            = "usgovvirginia"
    resource_group_name = azurerm_resource_group.jira_rg.name

    sku_name   = "GP_Gen5_4"
    version    = "9.6"
    storage_mb = 640000

    backup_retention_days        = var.jira_postgre_data_retention
    geo_redundant_backup_enabled = false
    auto_grow_enabled            = true

    administrator_login          = var.mp_db_username
    administrator_login_password = azurerm_key_vault_secret.db_pswd.value
    ssl_enforcement_enabled      = false

    tags                         = local.postgresqlserver_tags
}
