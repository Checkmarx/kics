package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    container_app := input.document[i].resource.azurerm_container_app[name]

    not common_lib.valid_key(container_app, "identity")

    result := {
        "documentId": input.document[i].id,
		"resourceType": "azurerm_container_app",
		"resourceName": tf_lib.get_resource_name(container_app, name),
		"searchKey": sprintf("azurerm_container_app[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'type' field should have the values 'SystemAssigned' or 'UserAssigned' defined inside the 'identity' block",
		"keyActualValue": "'identity' block is not defined",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_container_app", name], []),
        "remediationType": "addition",
        "remediation": "identity {\n\t\ttype = \"SystemAssigned, UserAssigned\"\n\t}",
    }
}