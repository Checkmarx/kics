#this code is a correct code for which the query should not find any result
resource "azurerm_postgresql_configuration" "example1" {
    name                = "log_duration"
    resource_group_name = "example1_resource_group_name"
    server_name         = "example1_server_name"
    value               = "on"
}

resource "azurerm_postgresql_configuration" "example2" {
    name                = "log_duration"
    resource_group_name = "example2_resource_group_name"
    server_name         = "example2_server_name"
    value               = "On"
}

resource "azurerm_postgresql_configuration" "example3" {
    name                = "log_duration"
    resource_group_name = "example3_resource_group_name"
    server_name         = "example3_server_name"
    value               = "ON"
}