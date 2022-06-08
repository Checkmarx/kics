package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	app := input.document[i].resource.azurerm_app_service[name]

	not common_lib.valid_key(app, "site_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name], []),
	}
}

CxPolicy[result] {
	app := input.document[i].resource.azurerm_app_service[name]

	not common_lib.valid_key(app.site_config, "http2_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("azurerm_app_service[%s].site_config", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config.http2_enabled' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config.http2_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config"], []),
	}
}

CxPolicy[result] {
	app := input.document[i].resource.azurerm_app_service[name]

	app.site_config.http2_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("azurerm_app_service[%s].site_config.http2_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config.http2_enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config.http2_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config", "http2_enabled"], []),
	}
}
