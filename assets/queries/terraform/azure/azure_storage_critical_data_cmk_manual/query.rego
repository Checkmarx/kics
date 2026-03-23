package Cx

import data.generic.terraform as tf_lib

# RULE 1: The 'customer_managed_key' block does not exist.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    not sa.customer_managed_key

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should use CMK if hosting critical data (Manual Verification)", [name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' is using Platform-Managed Keys", [name]),
    }
}

# RULE 2: The block exists but the 'key_vault_key_id' attribute is not defined.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.customer_managed_key
    object.get(sa.customer_managed_key, "key_vault_key_id", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s].customer_managed_key", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "If 'customer_managed_key' block is defined, it should include 'key_vault_key_id' for CMK encryption",
        "keyActualValue": "'key_vault_key_id' is not defined within the 'customer_managed_key' block",
    }
}
