package Cx

# REGLA 1: El bloque 'customer_managed_key' no existe.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    not sa.customer_managed_key

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should use CMK if hosting critical data (Manual Verification)", [name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' is using Platform-Managed Keys", [name]),
    }
}

# REGLA 2: El bloque existe pero el atributo 'key_vault_key_id' no está definido.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.customer_managed_key
    object.get(sa.customer_managed_key, "key_vault_key_id", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s.customer_managed_key", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "If 'customer_managed_key' block is defined, it should include 'key_vault_key_id' for CMK encryption",
        "keyActualValue": "'key_vault_key_id' is not defined within the 'customer_managed_key' block",
    }
}