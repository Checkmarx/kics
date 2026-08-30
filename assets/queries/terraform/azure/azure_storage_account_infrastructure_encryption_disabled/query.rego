package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: The 'infrastructure_encryption_enabled' attribute is missing.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    object.get(sa, "infrastructure_encryption_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should have 'infrastructure_encryption_enabled' set to true", [name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' is missing 'infrastructure_encryption_enabled'", [name]),
    }
}

# RULE 2: The 'infrastructure_encryption_enabled' attribute is set to false.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.infrastructure_encryption_enabled == false

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s].infrastructure_encryption_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "infrastructure_encryption_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'infrastructure_encryption_enabled' should be set to true",
        "keyActualValue": "'infrastructure_encryption_enabled' is set to false",
    }
}
