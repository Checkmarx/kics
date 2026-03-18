package Cx

is_target_linked(target, sa_name) {
    ref := sprintf("azurerm_storage_account.%s.id", [sa_name])
    contains(target, ref)
    contains(target, "blobServices/default")
}

is_target_linked(target, sa_name) {
    ref := sprintf("${azurerm_storage_account.%s.id}", [sa_name])
    contains(target, ref)
    contains(target, "blobServices/default")
}

# CASO 1: La cuenta de almacenamiento no tiene ningún Diagnostic Setting para Blobs.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    not diag_exists_for_sa(doc, name)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should have an 'azurerm_monitor_diagnostic_setting' for its blob service", [name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' does not have diagnostic logging enabled for blobs", [name]),
    }
}

diag_exists_for_sa(doc, sa_name) {
    diag := doc.resource.azurerm_monitor_diagnostic_setting[_]
    is_target_linked(diag.target_resource_id, sa_name)
}

# CASO 2: El Diagnostic Setting existe pero no tiene ningún bloque 'enabled_log'.
CxPolicy[result] {
    doc := input.document[i]
    diag := doc.resource.azurerm_monitor_diagnostic_setting[diag_name]
    
    contains(diag.target_resource_id, "blobServices/default")
    not diag.enabled_log

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_monitor_diagnostic_setting.%s", [diag_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Diagnostic Setting should have 'enabled_log' blocks defined",
        "keyActualValue": "Diagnostic Setting has no 'enabled_log' blocks",
    }
}

# CASO 3: El Diagnostic Setting tiene bloques 'enabled_log' pero el conjunto está incompleto.
CxPolicy[result] {
    doc := input.document[i]
    diag := doc.resource.azurerm_monitor_diagnostic_setting[diag_name]
    
    contains(diag.target_resource_id, "blobServices/default")
    diag.enabled_log

    required_categories := {"StorageRead", "StorageWrite", "StorageDelete"}
    present_categories := {cat | 
        log := diag.enabled_log[_]
        cat := log.category
    }

    not count(required_categories - present_categories) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_monitor_diagnostic_setting.%s.enabled_log", [diag_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "All required log categories (StorageRead, StorageWrite, StorageDelete) should be present",
        "keyActualValue": "One or more required log categories are missing in the 'enabled_log' configuration",
    }
}