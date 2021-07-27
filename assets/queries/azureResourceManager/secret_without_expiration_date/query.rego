package Cx

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.KeyVault/vaults/secrets"
	object.get(resource.properties, "attributes", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.type={{Microsoft.KeyVault/vaults/secrets}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'attributes.exp' property id defined",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'attributes' property defined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.KeyVault/vaults/secrets"
	object.get(resource.properties.attributes, "exp", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.type={{Microsoft.KeyVault/vaults/secrets}}.attributes", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'attributes.exp' property id defined",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'attributes.exp' property defined",
	}
}
