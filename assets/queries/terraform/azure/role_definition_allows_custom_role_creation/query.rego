package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_role_definition[name]

	actions := resource.permissions.actions

	allows_custom_roles_creation(actions)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_role_definition[%s].permissions.actions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_role_definition[%s].permissions.actions does not allow custom role creation", [name]),
		"keyActualValue": sprintf("azurerm_role_definition[%s].permissions.actions allows custom role creation", [name]),
	}
}

customRole := "Microsoft.Authorization/roleDefinitions/write"

allows_custom_roles_creation(actions) {
	count(actions) == 1
	options := {"*", customRole}
	actions[0] == options[x]
} else {
	count(actions) > 1
	actions[x] == customRole
}
