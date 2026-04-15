package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

targets := {"azurerm_mssql_server", "azurerm_mysql_flexible_server"}

# MANUAL RULE: Detects MySQL servers to request verification of the CONNECTION event.
CxPolicy[result] {
    doc := input.document[i]

    resource_type := targets[t]
    server := doc.resource[resource_type][name]

    result := {
        "documentId": doc.id,
        "resourceType": resource_type,
        "resourceName": tf_lib.get_resource_name(server, name),
        "searchKey": sprintf("%s[%s]", [resource_type, name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'audit_log_events' should include 'CONNECTION' for '%s.%s' (Manual Verification)", [resource_type, name]),
        "keyActualValue": "Audit log event configuration requires manual verification or check of 'azurerm_mysql_configuration'",
    }
}
