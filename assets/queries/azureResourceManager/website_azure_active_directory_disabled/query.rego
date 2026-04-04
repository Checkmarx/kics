package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"

	res := get_res(value, path)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": res.sk,
		"issueType": res.it,
		"keyExpectedValue": res.kev,
		"keyActualValue": res.kav,
		"searchLine": res.sl,
	}
}

get_res(value, path) = res {
	not common_lib.valid_key(value, "identity")
	res := {
		"sk": sprintf("%s.name={{%s}}", [common_lib.concat_path(path), value.name]),
		"it": "MissingAttribute",
		"kev": "resource with type 'Microsoft.Web/sites' should have the 'identity' property defined",
		"kav": "resource with type 'Microsoft.Web/sites' doesn't have 'identity' property defined",
		"sl": common_lib.build_search_line(path, ["name"])
	}
} else = res {
	not common_lib.valid_key(value.identity, "type")
	res := {
		"sk": sprintf("%s.name={{%s}}.identity", [common_lib.concat_path(path), value.name]),
		"it": "MissingAttribute",
		"kev": "resource with type 'Microsoft.Web/sites' should have the identity type set to 'SystemAssigned' or 'UserAssigned' and 'userAssignedIdentities' defined",
		"kav": "resource with type 'Microsoft.Web/sites' doesn't have the identity type set to 'SystemAssigned' or 'UserAssigned' and 'userAssignedIdentities' defined",
		"sl": common_lib.build_search_line(path, ["identity"])
	}
} else = res {
	common_lib.valid_key(value.identity, "type")
	not is_valid_identity(value.identity)
	res := {
		"sk": sprintf("%s.name={{%s}}.identity", [common_lib.concat_path(path), value.name]),
		"it": "IncorrectValue",
		"kev": "resource with type 'Microsoft.Web/sites' should have the identity type set to 'SystemAssigned' or 'UserAssigned'",
		"kav": "resource with type 'Microsoft.Web/sites' doesn't have the identity type set to 'SystemAssigned' or 'UserAssigned'",
		"sl": common_lib.build_search_line(path, ["identity"])
	}
}

is_valid_identity(identity) {
	identity.type == "SystemAssigned"
} else {
	identity.type == "UserAssigned"
	common_lib.valid_key(identity, "userAssignedIdentities")
}
