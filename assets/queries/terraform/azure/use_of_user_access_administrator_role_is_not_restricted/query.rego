package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_role_assignment[name]

    res := get_res(resource, name)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_role_assignment",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": res["sk"],
        "searchLine": res["sl"], 
        "issueType": "IncorrectValue",
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "remediation": null,
        "remediationType": null,
    }
}

get_res(resource, name) := res {
    common_lib.valid_key(resource, "role_definition_name")
    resource.role_definition_name == "User Access Administrator"

    res := {
        "sk": sprintf("azurerm_role_assignment[%s].role_definition_name", [name]),
        "sl": common_lib.build_search_line(["resource", "azurerm_role_assignment", name, "role_definition_name"], []),
        "kev": "'role_definition_name' field should not be defined to 'User Access Administrator'",
        "kav": "'role_definition_name' field is defined with 'User Access Administrator'",
    }
} else = res {
    common_lib.valid_key(resource, "role_definition_id")
    resource.role_definition_id == "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"

    res := {
        "sk": sprintf("azurerm_role_assignment[%s].role_definition_id", [name]),
        "sl": common_lib.build_search_line(["resource", "azurerm_role_assignment", name, "role_definition_id"], []),
        "kev": "'role_definition_id' field should not have an id associated with the 'User Access Administrator' role.",
        "kav": "'role_definition_id' field have an id associated with the 'User Access Administrator' role.",
    }
}