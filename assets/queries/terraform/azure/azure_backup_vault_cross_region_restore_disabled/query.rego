package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: Vault redundancy is GeoRedundant but 'cross_region_restore_enabled' is not defined.
# The attribute defaults to false when absent; it is only applicable to GeoRedundant vaults.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    vault.redundancy == "GeoRedundant"
    object.get(vault, "cross_region_restore_enabled", null) == null

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_data_protection_backup_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_data_protection_backup_vault[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_data_protection_backup_vault", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_data_protection_backup_vault.%s' should have 'cross_region_restore_enabled' set to true when 'redundancy' is 'GeoRedundant'", [name]),
        "keyActualValue": sprintf("'azurerm_data_protection_backup_vault.%s' is missing 'cross_region_restore_enabled' (defaults to false)", [name]),
    }
}

# RULE 2: Vault redundancy is GeoRedundant but 'cross_region_restore_enabled' is explicitly false.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    vault.redundancy == "GeoRedundant"
    vault.cross_region_restore_enabled == false

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_data_protection_backup_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_data_protection_backup_vault[%s].cross_region_restore_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_data_protection_backup_vault", name, "cross_region_restore_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'cross_region_restore_enabled' should be set to true when 'redundancy' is 'GeoRedundant'",
        "keyActualValue": "'cross_region_restore_enabled' is explicitly set to false",
    }
}
