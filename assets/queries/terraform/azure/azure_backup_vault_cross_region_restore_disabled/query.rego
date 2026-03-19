package Cx

# REGLA 1: Configuración Ausente.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    object.get(vault, "cross_region_restore_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_data_protection_backup_vault.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_data_protection_backup_vault.%s' should have 'cross_region_restore_enabled' set to true", [name]),
        "keyActualValue": sprintf("'azurerm_data_protection_backup_vault.%s' is missing 'cross_region_restore_enabled'", [name]),
    }
}

# REGLA 2: Configuración Incorrecta (Deshabilitado explícitamente).
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    vault.cross_region_restore_enabled == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_data_protection_backup_vault.%s.cross_region_restore_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'cross_region_restore_enabled' should be set to true",
        "keyActualValue": "'cross_region_restore_enabled' is set to false",
    }
}