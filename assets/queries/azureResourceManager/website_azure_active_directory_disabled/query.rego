package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"

	not common_lib.valid_key(value, "identity")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}", [value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'identity' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'identity' property defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.identity, "type")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.identity",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the identity type set to 'SystemAssigned' or 'UserAssigned' and 'userAssignedIdentities' defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have the identity type set to 'SystemAssigned' or 'UserAssigned' and 'userAssignedIdentities' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	common_lib.valid_key(value.identity, "type")
	not is_valid_identity(value.identity)

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.identity",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the identity type set to %s",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have the identity type set to %s",
	}
}

is_valid_identity(identity) {
	identity.type == "SystemAssigned"
} else {
	identity.type == "UserAssigned"
	common_lib.valid_key(identity, "userAssignedIdentities")
}
