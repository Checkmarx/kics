package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resources := {"azurerm_app_service", "azurerm_linux_web_app", "azurerm_windows_web_app"}

CxPolicy[result] {
	app := input.document[i].resource[resources[m]][name]

	not common_lib.valid_key(app, "site_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[m],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s]", [resources[m], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].site_config' should be defined and not null", [resources[m], name]),
		"keyActualValue": sprintf("'%s[%s].site_config' is undefined or null", [resources[m], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[m], name], []),
		"remediation": "site_config {\n\t\thttp2_enabled = true\n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	app := input.document[i].resource[resources[m]][name]

	not common_lib.valid_key(app.site_config, "http2_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[m],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s].site_config", [resources[m], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].site_config.http2_enabled' should be defined and not null", [resources[m], name]),
		"keyActualValue": sprintf("'%s[%s].site_config.http2_enabled' is undefined or null", [resources[m], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[m], name, "site_config"], []),
		"remediation": "http2_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	app := input.document[i].resource[resources[m]][name]

	app.site_config.http2_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[m],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s].site_config.http2_enabled", [resources[m], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].site_config.http2_enabled' should be set to true", [resources[m], name]),
		"keyActualValue": sprintf("'%s[%s].site_config.http2_enabled' is set to false", [resources[m], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[m], name, "site_config", "http2_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
