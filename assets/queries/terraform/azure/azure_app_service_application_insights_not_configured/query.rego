package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

targets := {
    "azurerm_linux_web_app",
    "azurerm_windows_web_app",
    "azurerm_linux_function_app",
    "azurerm_windows_function_app"
}

application_insights_keys := [
    "APPLICATIONINSIGHTS_CONNECTION_STRING",
    "APPINSIGHTS_INSTRUMENTATIONKEY",
]

# RULE 1: The 'app_settings' block is missing entirely.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[_]
    app := doc.resource[resource_type][name]

    not app.app_settings

    result := {
        "documentId": doc.id,
        "resourceType": resource_type,
        "resourceName": tf_lib.get_resource_name(app, name),
        "searchKey": sprintf("%s[%s]", [resource_type, name]),
        "searchLine": common_lib.build_search_line(["resource", resource_type, name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s.%s' should have 'app_settings' with an Application Insights key configured", [resource_type, name]),
        "keyActualValue": sprintf("'%s.%s' is missing 'app_settings'", [resource_type, name]),
    }
}

# RULE 2: 'app_settings' exists but neither Application Insights key is configured.
# Iterates application_insights_keys and counts how many are present; fires when none are found.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[_]
    app := doc.resource[resource_type][name]

    app.app_settings
    count({k | k := application_insights_keys[_]; app.app_settings[k]}) == 0

    result := {
        "documentId": doc.id,
        "resourceType": resource_type,
        "resourceName": tf_lib.get_resource_name(app, name),
        "searchKey": sprintf("%s[%s].app_settings", [resource_type, name]),
        "searchLine": common_lib.build_search_line(["resource", resource_type, name, "app_settings"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'app_settings' should contain '%s' or '%s'", [application_insights_keys[0], application_insights_keys[1]]),
        "keyActualValue": "'app_settings' does not contain any Application Insights configuration key",
    }
}
