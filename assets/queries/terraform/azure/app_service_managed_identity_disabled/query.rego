package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_app_service", "azurerm_linux_web_app", "azurerm_windows_web_app"}

CxPolicy[result] {
	function := input.document[i].resource[types[t]][name]

	not common_lib.valid_key(function, "identity")

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(function, name),
		"searchKey": sprintf("%s[%s]", [types[t],name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].identity' should be defined and not null", [types[t],name]),
		"keyActualValue": sprintf("'%s[%s].identity' is undefined or null", [types[t],name]),
		"searchLine": common_lib.build_search_line(["resource", types[t], name], []),
	}
}

