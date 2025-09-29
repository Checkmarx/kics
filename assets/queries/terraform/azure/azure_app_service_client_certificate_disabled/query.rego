package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := ["azurerm_app_service","azurerm_linux_web_app", "azurerm_windows_web_app"]

CxPolicy[result] {
	doc := input.document[i]
    resource := doc.resource[types[t]][name]

	not resource.site_config.http2_enabled  
	results := client_certificate_is_undefined_or_false(resource,name,types[t])
	results != ""

	result := {
		"documentId": doc.id,
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

client_certificate_is_undefined_or_false(resource,name,type) = results { # case of no "client_cert_enabled" field 
	field_name = get_field(type)
	not common_lib.valid_key(resource, field_name)

	results := {
		"searchKey" : sprintf("%s[%s]", [type, name]),
		"issueType" : "MissingAttribute",
		"keyExpectedValue" : sprintf("'%s[%s].%s' should be defined and set to true", [type, name, field_name]),
		"keyActualValue" : sprintf("'%s[%s].client_cert_enabeld' is undefined", [type, name]),
		"searchLine": common_lib.build_search_line(["resource", type , name], []),
		"remediation": sprintf("%s = true",[field_name]),
		"remediationType": "addition",
	}
	
} else = results { # case of no "client_cert_enabled" set to false
	field_name = get_field(type)
	resource[field_name] == false

	results := {
		"searchKey": sprintf("%s[%s].%s", [type, name, field_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].%s' should be set to true", [type, name, field_name]),
		"keyActualValue": sprintf("'%s[%s].%s' is set to false", [type, name, field_name]),
		"searchLine": common_lib.build_search_line(["resource", type, name, field_name], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

get_field("azurerm_app_service")     = "client_cert_enabled" 
get_field("azurerm_linux_web_app")   = "client_certificate_enabled"
get_field("azurerm_windows_web_app") = "client_certificate_enabled"