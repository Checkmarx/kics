package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_cosmosdb_account[name]
    not common_lib.valid_key(resource, "local_authentication_disabled")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_cosmosdb_account",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_cosmosdb_account[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_cosmosdb_account[%s].local_authentication_disabled should be true", [name]),
        "keyActualValue": sprintf("azurerm_cosmosdb_account[%s].local_authentication_disabled is not defined (defaults to false)", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_cosmosdb_account", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_cosmosdb_account[name]
    resource.local_authentication_disabled == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_cosmosdb_account",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_cosmosdb_account[%s].local_authentication_disabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_cosmosdb_account[%s].local_authentication_disabled should be true", [name]),
        "keyActualValue": sprintf("azurerm_cosmosdb_account[%s].local_authentication_disabled is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_cosmosdb_account", name, "local_authentication_disabled"], []),
    }
}
