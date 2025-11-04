package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resources := {"azurerm_app_service", "azurerm_linux_web_app", "azurerm_windows_web_app"}

CxPolicy[result] {
	app := input.document[i].resource[resources[m]][name]

	app.site_config.ftps_state == "AllAllowed"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[m],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s].site_config.ftps_state", [resources[m], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].site_config.ftps_state' should not be set to 'AllAllowed'", [resources[m], name]),
		"keyActualValue": sprintf("'%s[%s].site_config.ftps_state' is set to 'AllAllowed'", [resources[m], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[m], name, "site_config", "ftps_state"], []),
		"remediation": json.marshal({
			"before": "AllAllowed",
			"after": "FtpsOnly"
		}),
		"remediationType": "replacement",
	}
}
