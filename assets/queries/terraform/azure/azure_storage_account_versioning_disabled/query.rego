package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# CASE 1: The complete 'blob_properties' block is missing.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    not sa.blob_properties

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should have 'blob_properties' defined", [name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' is missing 'blob_properties'", [name]),
    }
}

# CASE 2: 'blob_properties' exists but the 'versioning_enabled' attribute is missing.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.blob_properties

    object.get(sa.blob_properties, "versioning_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s].blob_properties", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "blob_properties.versioning_enabled should be defined and set to true",
        "keyActualValue": "blob_properties.versioning_enabled is missing",
    }
}

# CASE 3: 'versioning_enabled' exists but is explicitly set to false.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.blob_properties.versioning_enabled == false

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s].blob_properties.versioning_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "blob_properties.versioning_enabled should be set to true",
        "keyActualValue": "blob_properties.versioning_enabled is set to false",
    }
}
