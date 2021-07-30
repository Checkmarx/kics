package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	resourceName := value.name

	to_number(split(value.apiVersion, "-")[0]) < 2019

	skValue := is_undefined(value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}%s", [resourceName, skValue]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' has the 'supportsHttpsTrafficOnly' property defined",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'supportsHttpsTrafficOnly' property defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	to_number(split(value.apiVersion, "-")[0]) >= 2019

	value.properties.supportsHttpsTrafficOnly == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Storage/storageAccounts}}.properties.supportsHttpsTrafficOnly",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' has the 'supportsHttpsTrafficOnly' property set to true",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'supportsHttpsTrafficOnly' set to true",
	}
}

is_undefined(value) = sk {
	not common_lib.valid_key(value, "properties")
	sk := ""
} else = sk {
	not common_lib.valid_key(value.properties, "supportsHttpsTrafficOnly")
	sk := ".properties"
}
