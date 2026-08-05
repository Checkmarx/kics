package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_synapse_workspace[name]
	
    res := get_res(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_synapse_workspace",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": res.sk,
		"issueType": res.it,
        "searchLine": res.sl,
		"keyExpectedValue": res.kev,
		"keyActualValue": res.kav,
	}
}

get_res(resource, name) = res {
    not common_lib.valid_key(resource, "managed_virtual_network_enabled")
    res := {
        "sk": sprintf("azurerm_synapse_workspace[%s]", [name]),
        "it": "MissingAttribute",
        "kev": "'managed_virtual_network_enabled' should be defined and set to true",
        "kav": "'managed_virtual_network_enabled' is not defined",
        "sl": common_lib.build_search_line(["resource", "azurerm_synapse_workspace", name], [])
    }
} else = res {
    resource.managed_virtual_network_enabled == false
    res := {
        "sk": sprintf("azurerm_synapse_workspace[%s].managed_virtual_network_enabled", [name]),
        "it": "IncorrectValue",
        "kev": "'managed_virtual_network_enabled' should be defined and set to true",
        "kav": "'managed_virtual_network_enabled' is set to false",
        "sl": common_lib.build_search_line(["resource", "azurerm_synapse_workspace", name, "managed_virtual_network_enabled"], [])
    }
}