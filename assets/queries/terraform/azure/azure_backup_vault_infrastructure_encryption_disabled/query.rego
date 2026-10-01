package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: The 'identity' block is absent, preventing Customer-Managed Key (CMK) encryption.
# Without a managed identity the vault is limited to Microsoft-managed platform encryption,
# removing customer control over key lifecycle and rotation.
CxPolicy[result] {
    doc := input.document[i]
    vault := doc.resource.azurerm_data_protection_backup_vault[name]

    not vault.identity

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_data_protection_backup_vault",
        "resourceName": tf_lib.get_resource_name(vault, name),
        "searchKey": sprintf("azurerm_data_protection_backup_vault[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_data_protection_backup_vault", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_data_protection_backup_vault.%s' should have an 'identity' block to enable Customer-Managed Key (CMK) encryption", [name]),
        "keyActualValue": sprintf("'azurerm_data_protection_backup_vault.%s' is missing the 'identity' block; vault uses Microsoft-managed platform encryption only", [name]),
    }
}
