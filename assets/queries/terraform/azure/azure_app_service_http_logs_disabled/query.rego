package Cx

targets := {"azurerm_linux_web_app", "azurerm_windows_web_app"}

# REGLA 1: El bloque 'logs' no existe en el App Service.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[t]
    app := doc.resource[resource_type][name]

    not app.logs

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s", [resource_type, name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s.%s' should have a 'logs' block defined", [resource_type, name]),
        "keyActualValue": sprintf("'%s.%s' is missing the 'logs' block", [resource_type, name]),
    }
}

# REGLA 2: El bloque 'logs' existe pero no tiene 'http_logs' configurado.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[t]
    app := doc.resource[resource_type][name]

    app.logs
    not app.logs.http_logs

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.%s.%s.logs", [resource_type, name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s.%s.logs' should have 'http_logs' configured", [resource_type, name]),
        "keyActualValue": sprintf("'%s.%s.logs' is missing 'http_logs'", [resource_type, name]),
    }
}