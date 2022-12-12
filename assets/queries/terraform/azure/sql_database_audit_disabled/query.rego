package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_database[name]

	not resource.threat_detection_policy

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_database",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_sql_database[%s].threat_detection_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'threat_detection_policy' should exist",
		"keyActualValue": "'threat_detection_policy' is missing",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_sql_database" ,name, "threat_detection_policy"], []),
		"remediation": "threat_detection_policy {\n\t\tstate = \"Enabled\"\n\t}\n",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_database[name]

	resource.threat_detection_policy.state == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_database",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_sql_database[%s].threat_detection_policy.state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'threat_detection_policy.state' equal 'Enabled'",
		"keyActualValue": "'threat_detection_policy.state' equal 'Disabled'",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_sql_database" ,name, "threat_detection_policy", "state"], []),
		"remediation": json.marshal({
			"before": "Disabled",
			"after": "Enabled"
		}),
		"remediationType": "replacement",
	}
}
