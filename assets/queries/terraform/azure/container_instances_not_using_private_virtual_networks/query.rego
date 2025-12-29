package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_container_group[name]

    res := get_res(resource, name)


	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_container_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
		"remediation": res["rem"],
		"remediationType": res["rt"],
	}
}

get_res(resource, name) = res {
    not common_lib.valid_key(resource, "ip_address_type")

    res := {
        "sk": sprintf("azurerm_container_group[%s]", [name]),
        "it": "MissingAttribute",
        "kev": "'ip_address_type' should be set to 'Private'",
        "kav": "'ip_address_type' is not defined",
        "sl": common_lib.build_search_line(["resource", "azurerm_container_group", name], []),
        "rem": "ip_address_type = \"Public\"",
        "rt": "addition",
    }
} else = res {
    not resource.ip_address_type == "Private"

    res := {
        "sk": sprintf("azurerm_container_group[%s].ip_address_type", [name]),
        "it": "IncorrectValue",
        "kev": "'ip_address_type' should be set to 'Private'",
        "kav": sprintf("'ip_address_type' is defined to '%s'", [resource.ip_address_type]),
        "sl": common_lib.build_search_line(["resource", "azurerm_container_group", name, "ip_address_type"], []),
        "rem": json.marshal({
			"before": resource.ip_address_type,
			"after": "Private",
		}),
        "rt": "replacement",
    }
}