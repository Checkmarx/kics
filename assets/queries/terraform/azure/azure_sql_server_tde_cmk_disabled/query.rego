package Cx

has_cmk_tde(doc, server_id) {
    tde := doc.resource.azurerm_mssql_server_transparent_data_encryption[_]
    check_id(tde.server_id, server_id)
    tde.key_vault_key_id
}

check_id(current, target) {
    current == target
}

check_id(current, target) {
    current == sprintf("${%s}", [target])
}

# REGLA 1: SQL Server sin configuración de TDE explícita o sin CMK.
CxPolicy[result] {
    doc := input.document[i]
    server := doc.resource.azurerm_mssql_server[name]
    server_id := sprintf("azurerm_mssql_server.%s.id", [name])

    not has_cmk_tde(doc, server_id)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_mssql_server.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_mssql_server.%s' should have an associated 'azurerm_mssql_server_transparent_data_encryption' resource with 'key_vault_key_id' set", [name]),
        "keyActualValue": sprintf("'azurerm_mssql_server.%s' is using Service-Managed Key (default) or lacks TDE resource", [name]),
    }
}