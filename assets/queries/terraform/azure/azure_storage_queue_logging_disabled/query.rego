package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

is_logging_valid(logging) {
    logging.read == true
    logging.write == true
    logging.delete == true
}

# CASE 1: 'logging' block missing in 'queue_properties' of azurerm_storage_account.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.queue_properties
    not sa.queue_properties.logging

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s].queue_properties", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "queue_properties"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "queue_properties.logging should be defined with read, write, and delete enabled",
        "keyActualValue": "queue_properties.logging is missing",
    }
}

# CASE 2: Incorrect 'logging' configuration in azurerm_storage_account.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    logging := sa.queue_properties.logging
    not is_logging_valid(logging)

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s].queue_properties.logging", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "queue_properties", "logging"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "logging should have read, write, and delete set to true",
        "keyActualValue": "logging has one or more required actions (read, write, delete) disabled",
    }
}

# CASE 3: 'logging' block missing in the azurerm_storage_account_queue_properties resource.
CxPolicy[result] {
    doc := input.document[i]
    props := doc.resource.azurerm_storage_account_queue_properties[name]

    not props.logging

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account_queue_properties",
        "resourceName": tf_lib.get_resource_name(props, name),
        "searchKey": sprintf("azurerm_storage_account_queue_properties[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_queue_properties", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "logging block should be defined in queue properties",
        "keyActualValue": "logging block is missing",
    }
}

# CASE 4: Incorrect 'logging' configuration in azurerm_storage_account_queue_properties.
CxPolicy[result] {
    doc := input.document[i]
    props := doc.resource.azurerm_storage_account_queue_properties[name]

    logging := props.logging
    not is_logging_valid(logging)

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account_queue_properties",
        "resourceName": tf_lib.get_resource_name(props, name),
        "searchKey": sprintf("azurerm_storage_account_queue_properties[%s].logging", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_queue_properties", name, "logging"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "logging should have read, write, and delete set to true",
        "keyActualValue": "logging is missing one or more required actions",
    }
}
