package Cx

# REGLA 1: Atributo 'infrastructure_encryption_enabled' ausente.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    object.get(sa, "infrastructure_encryption_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should have 'infrastructure_encryption_enabled' set to true", [name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' is missing 'infrastructure_encryption_enabled'", [name]),
    }
}

# REGLA 2: Atributo 'infrastructure_encryption_enabled' establecido en false.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.infrastructure_encryption_enabled == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s.infrastructure_encryption_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'infrastructure_encryption_enabled' should be set to true",
        "keyActualValue": "'infrastructure_encryption_enabled' is set to false",
    }
}