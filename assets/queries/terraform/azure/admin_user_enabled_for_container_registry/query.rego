package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_container_registry[name]

	resource.admin_enabled == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_container_registry[%s].admin_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'admin_enabled' equal 'false'",
		"keyActualValue": "'admin_enabled' equal 'true'",
	}
}
