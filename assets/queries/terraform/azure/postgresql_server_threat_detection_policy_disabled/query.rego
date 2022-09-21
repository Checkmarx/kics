package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	pg := input.document[i].resource.azurerm_postgresql_server[name]

	not common_lib.valid_key(pg, "threat_detection_policy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(pg, name),
		"searchKey": sprintf("azurerm_postgresql_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server[%s].threat_detection_policy' is a defined object", [name]),
		"keyActualValue": sprintf("'azurerm_postgresql_server[%s].threat_detection_policy' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_server", name], []),
		"remediation": "threat_detection_policy = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	pg := input.document[i].resource.azurerm_postgresql_server[name]

	pg.threat_detection_policy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(pg, name),
		"searchKey": sprintf("azurerm_postgresql_server[%s].threat_detection_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server[%s].threat_detection_policy.enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_postgresql_server[%s].threat_detection_policy.enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_server", name, "threat_detection_policy", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
