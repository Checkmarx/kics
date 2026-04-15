package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# MANUAL CHECK: Flags azurerm_mysql_flexible_server resources for human review.
# The 'audit_log_events' parameter is not an attribute on azurerm_mysql_flexible_server
# itself; it must be set via a separate azurerm_mysql_flexible_server_configuration resource
# with name = "audit_log_events" and value containing "CONNECTION".
# This query cannot verify that configuration automatically and requires manual confirmation.
CxPolicy[result] {
    doc := input.document[i]
    server := doc.resource.azurerm_mysql_flexible_server[name]

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_mysql_flexible_server",
        "resourceName": tf_lib.get_resource_name(server, name),
        "searchKey": sprintf("azurerm_mysql_flexible_server[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_mysql_flexible_server.%s' should have a paired 'azurerm_mysql_flexible_server_configuration' resource setting 'audit_log_events' to include 'CONNECTION'", [name]),
        "keyActualValue": sprintf("'azurerm_mysql_flexible_server.%s' requires manual verification: confirm an 'azurerm_mysql_flexible_server_configuration' with name='audit_log_events' and value including 'CONNECTION' is present", [name]),
    }
}
