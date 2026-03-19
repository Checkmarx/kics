package Cx

has_encryption_resource(doc, account_id) {
    enc := doc.resource.azurerm_netapp_account_encryption[_]
    check_id(enc.netapp_account_id, account_id)
}

check_id(current, target) {
    current == target
}

check_id(current, target) {
    current == sprintf("${%s}", [target])
}

has_inline_encryption(account) {
    account.encryption.key_source == "Microsoft.KeyVault"
}

# REGLA 1: La cuenta NetApp utiliza Platform-Managed Keys (falta configuración CMK).
CxPolicy[result] {
    doc := input.document[i]
    account := doc.resource.azurerm_netapp_account[name]
    account_id := sprintf("azurerm_netapp_account.%s.id", [name])

    not has_inline_encryption(account)
    not has_encryption_resource(doc, account_id)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_netapp_account.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_netapp_account.%s' should have 'encryption.key_source' set to 'Microsoft.KeyVault' or have an 'azurerm_netapp_account_encryption' resource associated", [name]),
        "keyActualValue": sprintf("'azurerm_netapp_account.%s' is using Platform-Managed Keys (default)", [name]),
    }
}