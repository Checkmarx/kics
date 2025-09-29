package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_function_app", "azurerm_linux_function_app", "azurerm_windows_function_app"}

CxPolicy[result] {
    function := input.document[i].resource.azurerm_function_app[name]

	results := client_certificate_not_required(function,name,types[t])
	results != ""

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
		"keyExpectedValue": sprintf("'%s[%s].client_cert_mode' should be defined and not null", [type, name]),
		"keyActualValue": sprintf("'%s[%s].client_cert_mode' is undefined or null", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name], []),
		"remediation": "client_cert_mode = \"Required\"",
		"remediationType": "addition",
	}
	
} else = results {
	field_name = get_field(type)
	function[field_name] != "Required"

	results := {
		"searchKey": sprintf("azurerm_function_app[%s].client_cert_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_function_app[%s].client_cert_mode' should be set to 'Required'", [name]),
		"keyActualValue": sprintf("'azurerm_function_app[%s].client_cert_mode' is not set to 'Required'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_function_app", name, "client_cert_mode"], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [function.client_cert_mode]),
			"after": "Required"
		}),
		"remediationType": "replacement",
	}
} else = ""

get_field("azurerm_function_app")     = "client_cert_mode" 
get_field("azurerm_linux_function_app")   = "client_certificate_mode"
get_field("azurerm_windows_function_app") = "client_certificate_mode"