package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_app_service", "azurerm_linux_web_app", "azurerm_windows_web_app"}

CxPolicy[result] {
	resource := input.document[i].resource[types[t]][name]

	results := https_undefined_or_false(resource,name,types[t])

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
		"remediation": results.remediation,
		"remediationType": results.remediationType,
	}
}

https_undefined_or_false(resource,name,type) = results {
	not common_lib.valid_key(resource, "https_only")

	results := {
		"searchKey": sprintf("%s[%s]", [type, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].https_only' should be defined and set to true", [type, name]),
		"keyActualValue": sprintf("'%s[%s].https_only' is undefined", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name], []),
		"remediation": "https_only = true",
		"remediationType": "addition",
	}
} else = results {
	resource.https_only != true

	results := {
		"searchKey": sprintf("%s[%s].https_only", [type, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].https_only' should be set to true", [type, name]),
		"keyActualValue": sprintf("'%s[%s].https_only' is not set to true", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type, name, "https_only"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
