package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_function_app", "azurerm_linux_function_app", "azurerm_windows_function_app"}

CxPolicy[result] {
    function := input.document[i].resource[types[t]][name]

	results := client_certificate_not_required(function,name,types[t])

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(function, name), 
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
		"remediation": results.remediation,
		"remediationType": results.remediationType,
	}
}

client_certificate_not_required(function,name,type) = results {
	field_name = get_field(type)
	not common_lib.valid_key(function, field_name)

	results := {
		"searchKey": sprintf("%s[%s]", [type, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].%s' should be defined and not null", [type, name, field_name]),
		"keyActualValue": sprintf("'%s[%s].%s' is undefined or null", [type, name, field_name]),
		"searchLine": common_lib.build_search_line(["resource", type, name], []),
		"remediation": sprintf("%s = \"Required\"",[field_name]),
		"remediationType": "addition",
	}
	
} else = results {
	field_name = get_field(type)
	function[field_name] != "Required"

	results := {
		"searchKey": sprintf("%s[%s].%s", [type, name, field_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].%s' should be set to 'Required'", [type, name, field_name]),
		"keyActualValue": sprintf("'%s[%s].%s' is not set to 'Required'", [type, name, field_name]),
		"searchLine": common_lib.build_search_line(["resource", type, name, field_name], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [function[field_name]]),
			"after": "Required"
		}),
		"remediationType": "replacement",
	}
}

get_field("azurerm_function_app")         = "client_cert_mode" 
get_field("azurerm_linux_function_app")   = "client_certificate_mode"
get_field("azurerm_windows_function_app") = "client_certificate_mode"