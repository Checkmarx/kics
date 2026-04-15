package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: Missing Configuration.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    object.get(vault, "cross_region_restore_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_data_protection_backup_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_data_protection_backup_vault[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_data_protection_backup_vault", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_data_protection_backup_vault.%s' should have 'cross_region_restore_enabled' set to true", [name]),
        "keyActualValue": sprintf("'azurerm_data_protection_backup_vault.%s' is missing 'cross_region_restore_enabled'", [name]),
    }
}

# RULE 2: Incorrect Configuration (Explicitly disabled).
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    vault.cross_region_restore_enabled == false

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_data_protection_backup_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_data_protection_backup_vault[%s].cross_region_restore_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_data_protection_backup_vault", name, "cross_region_restore_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'cross_region_restore_enabled' should be set to true",
        "keyActualValue": "'cross_region_restore_enabled' is set to false",
    }
}
