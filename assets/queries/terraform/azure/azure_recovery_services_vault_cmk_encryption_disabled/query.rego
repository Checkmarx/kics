package Cx

import data.generic.terraform as tf_lib

# REGLA 1: El bloque de encriptación no está definido.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_recovery_services_vault[name]

    not vault.encryption

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_recovery_services_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_recovery_services_vault[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_recovery_services_vault.%s' should have an 'encryption' block defined with a valid 'key_id'", [name]),
        "keyActualValue": sprintf("'azurerm_recovery_services_vault.%s' is missing the 'encryption' block (Platform-Managed Keys by default)", [name]),
    }
}
