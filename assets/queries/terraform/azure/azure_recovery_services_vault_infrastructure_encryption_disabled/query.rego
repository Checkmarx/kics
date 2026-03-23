package Cx

import data.generic.terraform as tf_lib

# RULE 1: The 'encryption' block is not defined.
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
        "keyExpectedValue": sprintf("'azurerm_recovery_services_vault.%s' should have an 'encryption' block defined", [name]),
        "keyActualValue": sprintf("'azurerm_recovery_services_vault.%s' is missing the 'encryption' block", [name]),
    }
}

# RULE 2: The 'infrastructure_encryption_enabled' attribute is not set to true.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_recovery_services_vault[name]

    vault.encryption
    object.get(vault.encryption, "infrastructure_encryption_enabled", false) != true

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_recovery_services_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_recovery_services_vault[%s].encryption.infrastructure_encryption_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "encryption.infrastructure_encryption_enabled should be set to true",
        "keyActualValue": sprintf("encryption.infrastructure_encryption_enabled is set to %v", [object.get(vault.encryption, "infrastructure_encryption_enabled", false)]),
    }
}
