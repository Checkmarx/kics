package Cx

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Authorization/roleDefinitions"

	regex.match("/$|/subscriptions/[\\w\\d-]+$|\\[subscription\\(\\)\\.id\\]", value.properties.assignableScopes[a]) == true

	allows_custom_roles_creation(value.properties.permissions[x].actions)

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Authorization/roleDefinitions}}.properties.permissions.actions",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Authorization/roleDefinitions' does not allow custom role creation",
		"keyActualValue": "resource with type 'Microsoft.Authorization/roleDefinitions' allows custom role creation (actions set to '*' or 'Microsoft.Authorization/roleDefinitions/write')",
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
