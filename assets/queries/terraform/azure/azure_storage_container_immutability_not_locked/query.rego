package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: The 'locked' attribute is not defined (Default is false/unlocked).
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.azurerm_storage_container_immutability_policy[name]

    object.get(policy, "locked", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_container_immutability_policy",
        "resourceName": tf_lib.get_resource_name(policy, name),
        "searchKey": sprintf("azurerm_storage_container_immutability_policy[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_container_immutability_policy", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_container_immutability_policy.%s' should have 'locked' set to true", [name]),
        "keyActualValue": sprintf("'azurerm_storage_container_immutability_policy.%s' is missing 'locked' attribute (default is false)", [name]),
    }
}

# RULE 2: The 'locked' attribute is explicitly set to false.
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.azurerm_storage_container_immutability_policy[name]

    policy.locked == false

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_container_immutability_policy",
        "resourceName": tf_lib.get_resource_name(policy, name),
        "searchKey": sprintf("azurerm_storage_container_immutability_policy[%s].locked", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_container_immutability_policy", name, "locked"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'locked' should be set to true",
        "keyActualValue": "'locked' is set to false",
    }
}
