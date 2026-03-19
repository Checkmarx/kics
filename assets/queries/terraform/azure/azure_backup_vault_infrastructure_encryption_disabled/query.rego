package Cx

# REGLA 1: Falta el bloque 'identity', necesario para gestionar cifrado avanzado.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    not vault.identity

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_data_protection_backup_vault.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_data_protection_backup_vault.%s' should have an 'identity' block to support advanced encryption", [name]),
        "keyActualValue": sprintf("'azurerm_data_protection_backup_vault.%s' is missing the 'identity' block", [name]),
    }
}