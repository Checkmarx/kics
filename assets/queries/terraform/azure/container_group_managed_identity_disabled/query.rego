package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    container_group := input.document[i].resource.azurerm_container_group[name]

    not common_lib.valid_key(container_group, "identity")

    result := {
        "documentId": input.document[i].id,
		"resourceType": "azurerm_container_group",
		"resourceName": tf_lib.get_resource_name(container_group, name),
		"searchKey": sprintf("azurerm_container_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'type' field should have the values 'SystemAssigned' and 'UserAssigned' defined inside the 'identity' block",
		"keyActualValue": "'identity' block is not defined",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_container_group", name], []),
        "remediationType": "addition",
        "remediation": "identity {\n\t\ttype = \"SystemAssigned, UserAssigned\"\n\t}",
    }
}