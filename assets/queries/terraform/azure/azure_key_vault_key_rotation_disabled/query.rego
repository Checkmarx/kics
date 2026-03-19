package Cx

# REGLA 1: La clave del Key Vault no tiene política de rotación configurada.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.azurerm_key_vault_key[name]

    not key.rotation_policy

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_key_vault_key.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_key_vault_key.%s' should have a 'rotation_policy' block defined", [name]),
        "keyActualValue": sprintf("'azurerm_key_vault_key.%s' does not have a 'rotation_policy' block defined", [name]),
    }
}