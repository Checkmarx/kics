package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] { #legacy support, 1.2 is the "latest" tls
	app := input.document[i].resource.azurerm_app_service[name]

	min_tls_version = to_number(app.site_config.min_tls_version)
	min_tls_version != 1.2

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("azurerm_app_service[%s].site_config.min_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].site_config.min_tls_version' should be set to '1.2'", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].site_config.min_tls_version' is not set to '1.2'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config", "min_tls_version"], []),
		"remediation": json.marshal({
			"before": sprintf("%.1f", [min_tls_version]),
			"after": "1.2"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] { # 1.3 is the latest tls
	types := {"azurerm_linux_web_app", "azurerm_windows_web_app"}
	app := input.document[i].resource[types[t]][name]

	results := minimum_tls_undefined_or_not_latest(app,types[t],name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
		"remediation": results.remediation,
		"remediationType": results.remediationType,
	}
}

# Case of undefined site_config - tls defaults to 1.2
minimum_tls_undefined_or_not_latest(app,type,name) = results {
	not common_lib.valid_key(app,"site_config")
	results := {
		"searchKey" : sprintf("%s[%s]", [type,name]),
		"issueType" : "MissingAttribute",
		"keyExpectedValue" : sprintf("'%s[%s].site_config.minimum_tls_version' should be defined and set to '1.3'", [type,name]),
		"keyActualValue" : sprintf("'%s[%s].site_config' is not defined", [type,name]),
		"searchLine" : common_lib.build_search_line(["resource", type, name], []),
		"remediation": null,
		"remediationType": null,
	}
# Case of undefined minimum_tls_version - tls defaults to 1.2
} else = results {
	not common_lib.valid_key(app.site_config,"minimum_tls_version")
	results := {
		"searchKey" : sprintf("%s[%s].site_config", [type,name]),
		"issueType" : "MissingAttribute",
		"keyExpectedValue" : sprintf("'%s[%s].site_config.minimum_tls_version' should be defined and set to '1.3'", [type,name]),
		"keyActualValue" : sprintf("'%s[%s].site_config.minimum_tls_version' is not defined", [type,name]),
		"searchLine" : common_lib.build_search_line(["resource", type, name, "site_config"], []),
		"remediation": "minimum_tls_version = 1.3",
		"remediationType": "addition",
	}
# Case of minimum_tls_version not set to 1.3
} else = results {
	min_tls_version = to_number(app.site_config.minimum_tls_version)
	min_tls_version != 1.3
	results := {
		"searchKey" : sprintf("%s[%s].site_config.minimum_tls_version", [type,name]),
		"issueType" : "IncorrectValue",
		"keyExpectedValue" : sprintf("'%s[%s].site_config.minimum_tls_version' should be set to '1.3'", [type,name]),
		"keyActualValue" : sprintf("'%s[%s].site_config.minimum_tls_version' is not set to '1.3'", [type,name]),
		"searchLine" : common_lib.build_search_line(["resource", type, name, "site_config", "minimum_tls_version"], []),
		"remediation" : json.marshal({
			"before": sprintf("%.1f", [min_tls_version]),
			"after": "1.3"
		}),
		"remediationType" : "replacement",
	}
}
