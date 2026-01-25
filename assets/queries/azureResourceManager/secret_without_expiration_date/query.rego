package Cx

import data.generic.common as common_lib

resourceTypes := ["Microsoft.KeyVault/vaults/secrets", "secrets"]

CxPolicy[result] {
	doc := input.document[i]

	[path, value] := walk(doc)

	value.type == resourceTypes[_]
	
	res := get_res(value, path)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": res.sk,
		"issueType": "MissingAttribute",
		"keyExpectedValue": res.kev,
		"keyActualValue": res.kav,
		"searchLine": res.sl,
	}
}

get_res(value, path) = res {
	not common_lib.valid_key(value.properties, "attributes")
	res := {
		"sk": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"kev": "resource with type 'Microsoft.KeyVault/vaults/secrets' should have 'attributes.exp' property id defined",
		"kav": "resource with type 'Microsoft.KeyVault/vaults/secrets' doesn't have 'attributes' property defined",
		"sl": common_lib.build_search_line(path, ["properties"]),
	}
} else = res {
	not common_lib.valid_key(value.properties.attributes, "exp")
	res := {
		"sk": sprintf("%s.name={{%s}}.properties.attributes", [common_lib.concat_path(path), value.name]),
		"kev": "resource with type 'Microsoft.KeyVault/vaults/secrets' should have 'attributes.exp' property id defined",
		"kav": "resource with type 'Microsoft.KeyVault/vaults/secrets' doesn't have 'attributes.exp' property defined",
		"sl": common_lib.build_search_line(path, ["properties", "attributes"]),
	}
}