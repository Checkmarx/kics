package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: The 'cross_region_restore_enabled' attribute is missing.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_recovery_services_vault[name]

    object.get(vault, "cross_region_restore_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_recovery_services_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_recovery_services_vault[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_recovery_services_vault.%s' should have 'cross_region_restore_enabled' set to true", [name]),
        "keyActualValue": sprintf("'azurerm_recovery_services_vault.%s' is missing 'cross_region_restore_enabled'", [name]),
    }
}

# RULE 2: The 'cross_region_restore_enabled' attribute is set to false.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_recovery_services_vault[name]

    vault.cross_region_restore_enabled == false

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_recovery_services_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_recovery_services_vault[%s].cross_region_restore_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'cross_region_restore_enabled' should be set to true",
        "keyActualValue": "'cross_region_restore_enabled' is set to false",
    }
}
