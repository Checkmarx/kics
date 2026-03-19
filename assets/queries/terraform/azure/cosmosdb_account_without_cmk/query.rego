package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_cosmosdb_account[name]
    not common_lib.valid_key(resource, "key_vault_key_id")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_cosmosdb_account",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_cosmosdb_account[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_cosmosdb_account[%s].key_vault_key_id should be defined", [name]),
        "keyActualValue": sprintf("azurerm_cosmosdb_account[%s].key_vault_key_id is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_cosmosdb_account", name], []),
    }
}
