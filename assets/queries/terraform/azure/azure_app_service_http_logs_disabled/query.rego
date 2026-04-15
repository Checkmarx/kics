package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

targets := {"azurerm_linux_web_app", "azurerm_windows_web_app"}

# RULE 1: The 'logs' block does not exist in the App Service.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[t]
    app := doc.resource[resource_type][name]

    not app.logs

    result := {
        "documentId": doc.id,
        "resourceType": resource_type,
        "resourceName": tf_lib.get_resource_name(app, name),
        "searchKey": sprintf("%s[%s]", [resource_type, name]),
        "searchLine": common_lib.build_search_line(["resource", resource_type, name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s.%s' should have a 'logs' block defined", [resource_type, name]),
        "keyActualValue": sprintf("'%s.%s' is missing the 'logs' block", [resource_type, name]),
    }
}

# RULE 2: The 'logs' block exists but does not have 'http_logs' configured.
CxPolicy[result] {
    doc := input.document[i]
    resource_type := targets[t]
    app := doc.resource[resource_type][name]

    app.logs
    not app.logs.http_logs

    result := {
        "documentId": doc.id,
        "resourceType": resource_type,
        "resourceName": tf_lib.get_resource_name(app, name),
        "searchKey": sprintf("%s[%s].logs", [resource_type, name]),
        "searchLine": common_lib.build_search_line(["resource", resource_type, name, "logs"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s.%s.logs' should have 'http_logs' configured", [resource_type, name]),
        "keyActualValue": sprintf("'%s.%s.logs' is missing 'http_logs'", [resource_type, name]),
    }
}
