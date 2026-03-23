package Cx

import data.generic.terraform as tf_lib

is_target_linked(target, sa_name) {
    ref := sprintf("azurerm_storage_account.%s.id", [sa_name])
    contains(target, ref)
    contains(target, "tableServices/default")
}

is_target_linked(target, sa_name) {
    ref := sprintf("${azurerm_storage_account.%s.id}", [sa_name])
    contains(target, ref)
    contains(target, "tableServices/default")
}

# CASE 1: The storage account has no Diagnostic Setting for Tables.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    not diag_exists_for_sa(doc, name)

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should have an 'azurerm_monitor_diagnostic_setting' for its table service", [name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' does not have diagnostic logging enabled for tables", [name]),
    }
}

diag_exists_for_sa(doc, sa_name) {
    diag := doc.resource.azurerm_monitor_diagnostic_setting[_]
    is_target_linked(diag.target_resource_id, sa_name)
}

# CASE 2: The Diagnostic Setting exists but has no 'enabled_log' blocks.
CxPolicy[result] {
    doc := input.document[i]
    diag := doc.resource.azurerm_monitor_diagnostic_setting[diag_name]

    contains(diag.target_resource_id, "tableServices/default")
    not diag.enabled_log

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_monitor_diagnostic_setting",
        "resourceName": tf_lib.get_resource_name(diag, diag_name),
        "searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s]", [diag_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Diagnostic Setting should have 'enabled_log' blocks defined",
        "keyActualValue": "Diagnostic Setting has no 'enabled_log' blocks",
    }
}

# CASE 3: The Diagnostic Setting has 'enabled_log' blocks but the set is incomplete.
CxPolicy[result] {
    doc := input.document[i]
    diag := doc.resource.azurerm_monitor_diagnostic_setting[diag_name]

    contains(diag.target_resource_id, "tableServices/default")
    diag.enabled_log

    required_categories := {"StorageRead", "StorageWrite", "StorageDelete"}
    present_categories := {cat |
        log := diag.enabled_log[_]
        cat := log.category
    }

    not count(required_categories - present_categories) == 0

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_monitor_diagnostic_setting",
        "resourceName": tf_lib.get_resource_name(diag, diag_name),
        "searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].enabled_log", [diag_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "All required log categories (StorageRead, StorageWrite, StorageDelete) should be present",
        "keyActualValue": "One or more required log categories are missing in the 'enabled_log' configuration for Table service",
    }
}
