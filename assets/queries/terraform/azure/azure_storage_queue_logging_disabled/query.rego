package Cx

is_logging_valid(logging) {
    logging.read == true
    logging.write == true
    logging.delete == true
}

# CASO 1: Bloque 'logging' ausente en 'queue_properties' de azurerm_storage_account.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]
    
    sa.queue_properties
    not sa.queue_properties.logging

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s.queue_properties", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "queue_properties.logging should be defined with read, write, and delete enabled",
        "keyActualValue": "queue_properties.logging is missing",
    }
}

# CASO 2: Configuración de 'logging' incorrecta en azurerm_storage_account.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]
    
    logging := sa.queue_properties.logging
    not is_logging_valid(logging)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s.queue_properties.logging", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "logging should have read, write, and delete set to true",
        "keyActualValue": "logging has one or more required actions (read, write, delete) disabled",
    }
}

# CASO 3: Bloque 'logging' ausente en el recurso azurerm_storage_account_queue_properties.
CxPolicy[result] {
    doc := input.document[i]
    props := doc.resource.azurerm_storage_account_queue_properties[name]

    not props.logging

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account_queue_properties.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "logging block should be defined in queue properties",
        "keyActualValue": "logging block is missing",
    }
}

# CASO 4: Configuración de 'logging' incorrecta en azurerm_storage_account_queue_properties.
CxPolicy[result] {
    doc := input.document[i]
    props := doc.resource.azurerm_storage_account_queue_properties[name]

    logging := props.logging
    not is_logging_valid(logging)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account_queue_properties.%s.logging", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "logging should have read, write, and delete set to true",
        "keyActualValue": "logging is missing one or more required actions",
    }
}