package Cx

targets := {
    "azurerm_cosmosdb_account",
    "azurerm_storage_account",
    "azurerm_mssql_server",
    "azurerm_key_vault",
    "azurerm_container_registry",
    "azurerm_servicebus_namespace",
    "azurerm_mariadb_server",
    "azurerm_postgresql_server",
    "azurerm_mysql_server",
    "azurerm_redis_cache",
    "azurerm_eventhub_namespace",
    "azurerm_automation_account",
    "azurerm_data_factory",
    "azurerm_synapse_workspace",
    "azurerm_search_service"
}

# REGLA MAESTRA: Verifica si los recursos de la lista targets tienen un Private Endpoint vinculado.
CxPolicy[result] {
    doc := input.document[i]
    
    resource_type := targets[t]
    resource_instances := doc.resource[resource_type]
    resource_instance := resource_instances[name]

    target_id := sprintf("%s.%s.id", [resource_type, name])

    private_endpoints := [pe |
        pe := doc.resource.azurerm_private_endpoint[_]
        conn := pe.private_service_connection
        check_resource_id(conn.private_connection_resource_id, target_id)
    ]

    count(private_endpoints) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s", [resource_type, name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s.%s' should be linked to an 'azurerm_private_endpoint'", [resource_type, name]),
        "keyActualValue": sprintf("'%s.%s' is not linked to any 'azurerm_private_endpoint' in this file", [resource_type, name]),
    }
}

check_resource_id(current, target) {
    current == target
}

check_resource_id(current, target) {
    current == sprintf("${%s}", [target])
}