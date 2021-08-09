package Cx

import data.generic.common as common_lib

resourceTypes := ["Microsoft.KeyVault/vaults/secrets", "secrets"]

CxPolicy[result] {
	doc := input.document[i]

	[path, value] := walk(doc)

	value.type == resourceTypes[_]
	not common_lib.valid_key(value.properties, "attributes")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'attributes.exp' property id defined",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'attributes' property defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]

	[path, value] := walk(doc)

	value.type == resourceTypes[_]
	not common_lib.valid_key(value.properties.attributes, "exp")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.attributes", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'attributes.exp' property id defined",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'attributes.exp' property defined",
	}
}
