package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"azurerm_function_app", "azurerm_linux_function_app", "azurerm_windows_function_app"}

CxPolicy[result] {
	app := input.document[i].resource[types[t]][name]

	not common_lib.valid_key(app, "site_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s]", [types[t], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].site_config' should be defined and not null", [types[t], name]),
		"keyActualValue": sprintf("'%s[%s].site_config' is undefined or null", [types[t], name]),
		"searchLine": common_lib.build_search_line(["resource", types[t], name], []),
		"remediation": "site_config {\n\t\thttp2_enabled = true\n\t}\n",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	app := input.document[i].resource[types[t]][name]

	not common_lib.valid_key(app.site_config, "http2_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s].site_config", [types[t], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].site_config.http2_enabled' should be defined and not null", [types[t], name]),
		"keyActualValue": sprintf("'%s[%s].site_config.http2_enabled' is undefined or null", [types[t], name]),
		"searchLine": common_lib.build_search_line(["resource", types[t], name, "site_config"], []),
		"remediation": "http2_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	app := input.document[i].resource[types[t]][name]

	app.site_config.http2_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s].site_config.http2_enabled", [types[t], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].site_config.http2_enabled' should be set to true", [types[t], name]),
		"keyActualValue": sprintf("'%s[%s].site_config.http2_enabled' is set to false", [types[t], name]),
		"searchLine": common_lib.build_search_line(["resource", types[t], name, "site_config", "http2_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
