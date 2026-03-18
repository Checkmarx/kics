package Cx

# REGLA 1: El bloque 'encryption' no está definido.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_recovery_services_vault[name]

    not vault.encryption

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_recovery_services_vault.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_recovery_services_vault.%s' should have an 'encryption' block defined", [name]),
        "keyActualValue": sprintf("'azurerm_recovery_services_vault.%s' is missing the 'encryption' block", [name]),
    }
}

# REGLA 2: El atributo 'infrastructure_encryption_enabled' no está en true.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_recovery_services_vault[name]

    vault.encryption
    object.get(vault.encryption, "infrastructure_encryption_enabled", false) != true

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_recovery_services_vault.%s.encryption.infrastructure_encryption_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "encryption.infrastructure_encryption_enabled should be set to true",
        "keyActualValue": sprintf("encryption.infrastructure_encryption_enabled is set to %v", [object.get(vault.encryption, "infrastructure_encryption_enabled", false)]),
    }
}