package Cx

import data.generic.terraform as tf_lib

has_cmk_configured(doc, vault_id) {
    cmk := doc.resource.azurerm_data_protection_backup_vault_customer_managed_key[_]
    cmk.data_protection_backup_vault_id == vault_id
    cmk.key_vault_key_id
}

# RULE 1: The Backup Vault does not have CMK encryption configured through the association resource.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    vault_id := sprintf("${azurerm_data_protection_backup_vault.%s.id}", [name])

    not has_cmk_configured(doc, vault_id)

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_data_protection_backup_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_data_protection_backup_vault[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_data_protection_backup_vault.%s' should be associated with an 'azurerm_data_protection_backup_vault_customer_managed_key' resource", [name]),
        "keyActualValue": sprintf("'azurerm_data_protection_backup_vault.%s' is using Platform-Managed Keys (default)", [name]),
    }
}
