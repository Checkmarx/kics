package Cx

# REGLA 1: El atributo 'locked' no está definido (Default es false/unlocked).
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.azurerm_storage_container_immutability_policy[name]

    object.get(policy, "locked", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_container_immutability_policy.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_container_immutability_policy.%s' should have 'locked' set to true", [name]),
        "keyActualValue": sprintf("'azurerm_storage_container_immutability_policy.%s' is missing 'locked' attribute (default is false)", [name]),
    }
}

# REGLA 2: El atributo 'locked' está explícitamente a false.
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.azurerm_storage_container_immutability_policy[name]

    policy.locked == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_container_immutability_policy.%s.locked", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'locked' should be set to true",
        "keyActualValue": "'locked' is set to false",
    }
}