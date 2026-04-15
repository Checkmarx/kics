package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

targets := {
    "azurerm_linux_web_app",
    "azurerm_windows_web_app",
    "azurerm_linux_function_app",
    "azurerm_windows_function_app"
}

# RULE 1: The 'app_settings' block does not exist at all.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[t]
    app := doc.resource[resource_type][name]

    not app.app_settings

    result := {
        "documentId": doc.id,
        "resourceType": resource_type,
        "resourceName": tf_lib.get_resource_name(app, name),
        "searchKey": sprintf("%s[%s]", [resource_type, name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s.%s' should have 'app_settings' defined", [resource_type, name]),
        "keyActualValue": sprintf("'%s.%s' is missing 'app_settings'", [resource_type, name]),
    }
}

# RULE 2: The 'app_settings' block exists but does not have any App Insights key.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[t]
    app := doc.resource[resource_type][name]

    app.app_settings
    not app.app_settings["APPLICATIONINSIGHTS_CONNECTION_STRING"]
    not app.app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"]

    result := {
        "documentId": doc.id,
        "resourceType": resource_type,
        "resourceName": tf_lib.get_resource_name(app, name),
        "searchKey": sprintf("%s[%s].app_settings", [resource_type, name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'app_settings' should contain 'APPLICATIONINSIGHTS_CONNECTION_STRING'",
        "keyActualValue": "'app_settings' does not contain Application Insights configuration",
    }
}
