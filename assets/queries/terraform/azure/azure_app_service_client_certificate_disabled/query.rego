package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
    resource := doc.resource.azurerm_app_service[name]

    not common_lib.valid_key(resource, "client_cert_enabled")
	not has_http2_protocol_enabled(resource)

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name), 
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].client_cert_enabeld' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service" ,name], []),
		"remediation": "client_cert_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	doc := input.document[i]
    resource := doc.resource.azurerm_app_service[name]

	resource.client_cert_enabled == false
    not http2_defined_to_false(resource)
	not has_http2_protocol_enabled(resource)

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name), 
		"searchKey": sprintf("azurerm_app_service[%s].client_cert_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' is true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service", name, "client_cert_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	doc := input.document[i]
    resource := doc.resource.azurerm_app_service[name]

	resource.client_cert_enabled == false
    http2_defined_to_false(resource)
	not has_http2_protocol_enabled(resource)

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name), 
		"searchKey": sprintf("azurerm_app_service[%s].client_cert_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' or 'azurerm_app_service[%s].site_config.http2_enabled' are true", [name, name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].client_cert_enabled' and 'azurerm_app_service[%s].site_config.http2_enabled' set to false", [name, name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service" ,name, "client_cert_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

has_http2_protocol_enabled(resource) {
	common_lib.valid_key(resource, "site_config")
    common_lib.valid_key(resource.site_config, "http2_enabled")
    resource.site_config.http2_enabled
}

http2_defined_to_false (resource) {
    common_lib.valid_key(resource, "site_config")
    common_lib.valid_key(resource.site_config, "http2_enabled")
    resource.site_config.http2_enabled == false
}