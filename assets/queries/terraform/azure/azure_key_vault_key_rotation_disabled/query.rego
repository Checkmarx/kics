package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: The Key Vault key does not have a rotation policy configured.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.azurerm_key_vault_key[name]

    not key.rotation_policy

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_key_vault_key",
        "resourceName": tf_lib.get_resource_name(key, name),
        "searchKey": sprintf("azurerm_key_vault_key[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_key", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_key_vault_key.%s' should have a 'rotation_policy' block defined", [name]),
        "keyActualValue": sprintf("'azurerm_key_vault_key.%s' does not have a 'rotation_policy' block defined", [name]),
    }
}
