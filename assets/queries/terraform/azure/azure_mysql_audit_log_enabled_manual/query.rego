package Cx

targets := {"azurerm_mssql_server", "azurerm_mysql_flexible_server"}

# REGLA MANUAL: Detecta servidores MySQL para solicitar verificación de logs de auditoría.
CxPolicy[result] {
    doc := input.document[i]
    
    resource_type := targets[t]
    server := doc.resource[resource_type][name]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s", [resource_type, name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'audit_log_enabled' should be set to 'ON' for '%s.%s' (Manual Verification)", [resource_type, name]),
        "keyActualValue": "Logging configuration requires manual verification or check of 'azurerm_mysql_configuration' resources",
    }
}