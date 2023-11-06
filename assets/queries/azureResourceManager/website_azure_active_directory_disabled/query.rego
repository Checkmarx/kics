package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"

	not common_lib.valid_key(value, "identity")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' should have the 'identity' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'identity' property defined",
		"searchLine": common_lib.build_search_line(path, ["name"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.identity, "type")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.identity", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' should have the identity type set to 'SystemAssigned' or 'UserAssigned' and 'userAssignedIdentities' defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have the identity type set to 'SystemAssigned' or 'UserAssigned' and 'userAssignedIdentities' defined",
		"searchLine": common_lib.build_search_line(path, ["identity"]),
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
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.identity", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' should have the identity type set to %s",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have the identity type set to %s",
		"searchLine": common_lib.build_search_line(path, ["identity"]),
	}
}

is_valid_identity(identity) {
	identity.type == "SystemAssigned"
} else {
	identity.type == "UserAssigned"
	common_lib.valid_key(identity, "userAssignedIdentities")
}
