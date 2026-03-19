package Cx

targets := {
    "azurerm_linux_web_app", 
    "azurerm_windows_web_app", 
    "azurerm_linux_function_app", 
    "azurerm_windows_function_app"
}

# REGLA 1: El bloque 'app_settings' no existe en absoluto.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[t]
    app := doc.resource[resource_type][name]

    not app.app_settings

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s", [resource_type, name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s.%s' should have 'app_settings' defined", [resource_type, name]),
        "keyActualValue": sprintf("'%s.%s' is missing 'app_settings'", [resource_type, name]),
    }
}

# REGLA 2: El bloque 'app_settings' existe pero no tiene ninguna clave de App Insights.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[t]
    app := doc.resource[resource_type][name]

    app.app_settings
    not app.app_settings["APPLICATIONINSIGHTS_CONNECTION_STRING"]
    not app.app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s.app_settings", [resource_type, name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'app_settings' should contain 'APPLICATIONINSIGHTS_CONNECTION_STRING'",
        "keyActualValue": "'app_settings' does not contain Application Insights configuration",
    }
}