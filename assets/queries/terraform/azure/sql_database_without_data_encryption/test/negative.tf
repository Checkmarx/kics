resource "azurerm_mssql_database" "negative_1" {
  name           = "negative_1-db"
  server_id      = azurerm_mssql_server.negative_1.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true
  enclave_type   = "VBS"

  # missing "transparent_data_encryption_enabled" - defaults to true
}

resource "azurerm_mssql_database" "negative_2" {
  name           = "negative_2-db"
  server_id      = azurerm_mssql_server.negative_2.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true
  enclave_type   = "VBS"

  transparent_data_encryption_enabled = true
}
