package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	resourceName := value.name

	to_number(split(value.apiVersion, "-")[0]) < 2017

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.type={{Microsoft.Storage/storageAccounts}}.apiVersion=%s", [value.apiVersion]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' apiVersion is newer than 2017 and enables setting networkAcls",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' apiVersion is older than 2017 and doesn't enable setting networkAcls",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	to_number(split(value.apiVersion, "-")[0]) >= 2017

	sk := is_network_acl_undefined(value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.type={{Microsoft.Storage/storageAccounts}}%s", [sk]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' has the 'properties.networkAcls.defaultAction' defined",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'properties.networkAcls.defaultAction' defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	to_number(split(value.apiVersion, "-")[0]) >= 2017

	lower(value.properties.networkAcls.defaultAction) == "allow"

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Storage/storageAccounts}}.properties.networkAcls.defaultAction",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' has the 'properties.networkAcls.defaultAction' set to 'Deny'",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' has the 'properties.networkAcls.defaultAction' set to 'Allow'",
	}
}

is_network_acl_undefined(value) = sk {
	not common_lib.valid_key(value.properties.networkAcls, "defaultAction")
	sk := ".properties.networkAcls"
} else = sk {
	not common_lib.valid_key(value.properties, "networkAcls")
	sk := ".properties"
} else = sk {
	not common_lib.valid_key(value, "properties")
	sk := ""
}
