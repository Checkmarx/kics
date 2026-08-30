package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_key_vault_key[name]
    not common_lib.valid_key(resource, "expiration_date")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_key_vault_key",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_key_vault_key[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_key_vault_key[%s].expiration_date should be set", [name]),
        "keyActualValue": sprintf("azurerm_key_vault_key[%s].expiration_date is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_key", name], []),
    }
}
