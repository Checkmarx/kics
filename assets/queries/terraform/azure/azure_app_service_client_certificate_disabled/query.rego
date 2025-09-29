package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
    resource := doc.resource.azurerm_app_service[name]

	not resource.site_config.http2_enabled  
	results := client_certificate_is_undefined_or_false(resource,name)
	results != ""

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
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

client_certificate_is_undefined_or_false(resource,name) = results {
	not common_lib.valid_key(resource, "client_cert_enabled")

	results := {
		"searchKey" : sprintf("azurerm_app_service[%s]", [name]),
		"issueType" : "MissingAttribute",
		"keyExpectedValue" : sprintf("'azurerm_app_service[%s].client_cert_enabled' should be defined and set to true", [name]),
		"keyActualValue" : sprintf("'azurerm_app_service[%s].client_cert_enabeld' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service" ,name], []),
		"remediation": "client_cert_enabled = true",
		"remediationType": "addition",
	}
	
} else = results {
	resource.client_cert_enabled == false

	results := {
		"searchKey": sprintf("azurerm_app_service[%s].client_cert_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service", name, "client_cert_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}