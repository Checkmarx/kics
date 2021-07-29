package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.KeyVault/vaults"

	fields := {"enableSoftDelete", "enablePurgeProtection"}
	not common_lib.valid_key(value.properties, fields[x])

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.KeyVault/vaults}}.properties",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.KeyVault/vaults' has '%s' property defined", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.KeyVault/vaults' doesn't have '%s' property defined", [fields[x]]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.KeyVault/vaults"

	fields := {"enableSoftDelete", "enablePurgeProtection"}
	value.properties[fields[x]] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.type={{Microsoft.KeyVault/vaults}}.properties.%s", [fields[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.KeyVault/vaults' has '%s' property set to true", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.KeyVault/vaults' doesn't have '%s' property set to true", [fields[x]]),
	}
}
