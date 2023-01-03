package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	scc := input.document[i].resource.azurerm_security_center_contact[name]

	not common_lib.valid_key(scc, "email")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_security_center_contact",
		"resourceName": tf_lib.get_resource_name(scc, name),
		"searchKey": sprintf("azurerm_security_center_contact[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_security_center_contact[%s].email' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_security_center_contact[%s].email' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_security_center_contact", name], []),
	}
}
