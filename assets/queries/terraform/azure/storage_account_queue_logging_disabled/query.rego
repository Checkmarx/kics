package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[name]
    not common_lib.valid_key(resource, "queue_properties")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_storage_account",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_storage_account[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_storage_account[%s].queue_properties.logging should be defined with delete, read, and write enabled", [name]),
        "keyActualValue": sprintf("azurerm_storage_account[%s].queue_properties is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[name]
    logging := resource.queue_properties.logging
    logging.delete == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_storage_account",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_storage_account[%s].queue_properties.logging.delete", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_storage_account[%s].queue_properties.logging.delete should be true", [name]),
        "keyActualValue": sprintf("azurerm_storage_account[%s].queue_properties.logging.delete is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "queue_properties", "logging", "delete"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[name]
    logging := resource.queue_properties.logging
    logging.read == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_storage_account",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_storage_account[%s].queue_properties.logging.read", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_storage_account[%s].queue_properties.logging.read should be true", [name]),
        "keyActualValue": sprintf("azurerm_storage_account[%s].queue_properties.logging.read is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "queue_properties", "logging", "read"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[name]
    logging := resource.queue_properties.logging
    logging.write == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_storage_account",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_storage_account[%s].queue_properties.logging.write", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_storage_account[%s].queue_properties.logging.write should be true", [name]),
        "keyActualValue": sprintf("azurerm_storage_account[%s].queue_properties.logging.write is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "queue_properties", "logging", "write"], []),
    }
}
