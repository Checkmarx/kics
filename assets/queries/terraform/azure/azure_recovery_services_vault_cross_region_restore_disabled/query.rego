package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: Vault storage_mode_type is GeoRedundant but 'cross_region_restore_enabled' is not defined.
# cross_region_restore_enabled can only be enabled when storage_mode_type is GeoRedundant;
# when absent it defaults to false.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_recovery_services_vault[name]

    vault.storage_mode_type == "GeoRedundant"
    object.get(vault, "cross_region_restore_enabled", null) == null

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_recovery_services_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_recovery_services_vault[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_recovery_services_vault.%s' should have 'cross_region_restore_enabled' set to true when 'storage_mode_type' is 'GeoRedundant'", [name]),
        "keyActualValue": sprintf("'azurerm_recovery_services_vault.%s' is missing 'cross_region_restore_enabled' (defaults to false)", [name]),
    }
}

# RULE 2: Vault storage_mode_type is GeoRedundant but 'cross_region_restore_enabled' is explicitly false.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_recovery_services_vault[name]

    vault.storage_mode_type == "GeoRedundant"
    vault.cross_region_restore_enabled == false

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_recovery_services_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_recovery_services_vault[%s].cross_region_restore_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "cross_region_restore_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'cross_region_restore_enabled' should be set to true when 'storage_mode_type' is 'GeoRedundant'",
        "keyActualValue": "'cross_region_restore_enabled' is explicitly set to false",
    }
}
