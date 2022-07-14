package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Authorization/roleDefinitions"

	regex.match("/$|/subscriptions/[\\w\\d-]+$|\\[subscription\\(\\)\\.id\\]", value.properties.assignableScopes[a]) == true

	allows_custom_roles_creation(value.properties.permissions[x].actions)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.permissions.actions", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Authorization/roleDefinitions' should not allow custom role creation",
		"keyActualValue": "resource with type 'Microsoft.Authorization/roleDefinitions' allows custom role creation (actions set to '*' or 'Microsoft.Authorization/roleDefinitions/write')",
		"searchLine": common_lib.build_search_line(path, ["properties", "permissions", x, "actions"]),
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
