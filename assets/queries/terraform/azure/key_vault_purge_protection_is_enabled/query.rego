package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
    key_vault := input.document[i].resource.azurerm_key_vault[name]

    res := get_res(key_vault, name)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_key_vault",
        "resourceName": tf_lib.get_resource_name(key_vault, name),
        "searchKey": res["sk"],
        "searchLine": res["sl"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "remediation": res["rem"],
        "remediationType": res["rtype"],
    }
}

get_res(resource, name) = res {
    not common_lib.valid_key(resource, "purge_protection_enabled")

    res := {
        "it": "MissingAttribute",
        "sk": sprintf("azurerm_key_vault[%s]", [name]),
        "sl": common_lib.build_search_line(["resource", "azurerm_key_vault", name], []),
        "kev": "'purge_protection_enabled' should be defined and set to true",
        "kav": "'purge_protection_enabled' is not defined",
        "rem": "purge_protection_enabled = true",
        "rtype": "addition"
    }
} else = res {
    not resource.purge_protection_enabled == true

    res := {
        "it": "IncorrectValue",
        "sk": sprintf("azurerm_key_vault[%s].purge_protection_enabled", [name]),
        "sl": common_lib.build_search_line(["resource", "azurerm_key_vault", name, "purge_protection_enabled"], []),
        "kev": "'purge_protection_enabled' field should be set to true",
        "kav": "'purge_protection_enabled' is not set to true",
        "rem": json.marshal({
            "before": "false",
            "after": "true"
        }),
        "rtype": "replacement"
    }
}