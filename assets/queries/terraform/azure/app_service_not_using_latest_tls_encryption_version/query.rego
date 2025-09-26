package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] { #legacy support, 1.2 is the latest tls
	app := input.document[i].resource.azurerm_app_service[name]

	not min_version_is_latest(app.site_config.min_tls_version,1.2,"1.2")

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
			"before": sprintf("%.1f", [app.site_config.min_tls_version]),
			"after": "1.2"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] { # 1.3 is the latest tls 
	resources := {"azurerm_linux_web_app", "azurerm_windows_web_app"}
	app := input.document[i].resource[resources[t]][name]

	not min_version_is_latest(app.site_config.minimum_tls_version,1.3,"1.3")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[t],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s].site_config.minimum_tls_version", [resources[t],name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].site_config.minimum_tls_version' should be set to '1.3'", [resources[t],name]),
		"keyActualValue": sprintf("'%s[%s].site_config.minimum_tls_version' is not set to '1.3'", [resources[t],name]),
		"searchLine": common_lib.build_search_line(["resource", resources[t], name, "site_config", "minimum_tls_version"], []),
		"remediation": json.marshal({
			"before": sprintf("%.1f", [app.site_config.minimum_tls_version]),
			"after": "1.3"
		}),
		"remediationType": "replacement",
	}
}

min_version_is_latest(min_version,ver_number,ver_string) {
	min_version == ver_number
} else {
	min_version == ver_string
}
