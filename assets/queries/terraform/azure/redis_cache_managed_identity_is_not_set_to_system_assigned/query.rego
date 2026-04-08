package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_redis_cache[name]

    res := get_res(resource, name)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_redis_cache",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": res["sk"],
        "issueType": "MissingAttribute",
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "searchLine": res["sl"],
        "remediation": res["rem"],
        "remediationType": res["rtype"],
    }
}

get_res(resource, name) = res {
    not common_lib.valid_key(resource, "identity")

    res := {
        "sk": sprintf("azurerm_redis_cache[%s]", [name]),
        "kev": "'identity' block should have 'SystemAssigned' defined on 'type' field",
        "kav": "'identity' block is not defined",
        "sl": common_lib.build_search_line(["resource", "azurerm_redis_cache", name], []),
        "rem": "identity{\n\t\ttype = \"SystemAssigned\"\n\t}",
        "rtype": "addition",
    }
} else = res {
    not contains(resource.identity.type, "SystemAssigned")

    content_inside_identity_type_field := trim_left(trim_right(resource.identity.type, "\""), "\"")

    res := {
        "sk": sprintf("azurerm_redis_cache[%s]", [name]),
        "kev": "'identity' block should have 'SystemAssigned' defined on 'type' field",
        "kav": "'identity' block does not have 'SystemAssigned' defined on 'type' field",
        "sl": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "identity", "type"], []),
        "rem": json.marshal({
            "before": resource.identity.type,
            "after": sprintf("%s, SystemAssigned", [content_inside_identity_type_field])
        }),
        "rtype": "replacement",
    }
}