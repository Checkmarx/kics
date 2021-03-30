package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_database[name]

	not resource.threat_detection_policy

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_sql_database[%s].threat_detection_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'threat_detection_policy' exists",
		"keyActualValue": "'threat_detection_policy' is missing",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_database[name]

	resource.threat_detection_policy.state == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_sql_database[%s].threat_detection_policy.state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'threat_detection_policy.state' equal 'Enabled'",
		"keyActualValue": "'threat_detection_policy.state' equal 'Disabled'",
	}
}
