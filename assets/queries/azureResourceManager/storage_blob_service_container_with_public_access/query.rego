package Cx

import data.generic.common as common_lib

publicOptions := {"Container", "Blob"}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts/blobServices/containers"

	value.properties.publicAccess == publicOptions[o]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.properties.publicAccess", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts/blobServices/containers' doesn't have 'publicAccess' property set to 'Container' or 'Blob'",
		"keyActualValue": sprintf("resource with type 'Microsoft.Storage/storageAccounts/blobServices/containers' has 'publicAccess' property set to '%s'", [publicOptions[o]]),
		"searchLine": common_lib.build_search_line(path, ["properties", "publicAccess"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts/blobServices"

	[childPath, childValue] := walk(value.resources)

	childValue.type == "containers"
	childValue.properties.publicAccess == publicOptions[o]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.resources.name=%s.properties.publicAccess", [common_lib.concat_path(path), value.name, childValue.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'containers' doesn't have 'publicAccess' property set to 'Container' or 'Blob'",
		"keyActualValue": sprintf("resource with type 'containers' has 'publicAccess' property set to '%s'", [publicOptions[o]]),
		"searchLine": common_lib.build_search_line(childPath, ["properties", "publicAccess"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"

	[childPath, childValue] := walk(value.resources)

	childValue.type == "blobServices/containers"
	childValue.properties.publicAccess == publicOptions[o]

	result := {
		"documentId": input.document[i].id,
        "searchKey": sprintf("%s.name=%s.resources.name=%s.properties.publicAccess", [common_lib.concat_path(path), value.name, childValue.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'blobServices/containers' doesn't have 'publicAccess' property set to 'Container' or 'Blob'",
		"keyActualValue": sprintf("resource with type 'blobServices/containers' has 'publicAccess' property set to '%s'", [publicOptions[o]]),
		"searchLine": common_lib.build_search_line(childPath, ["properties", "publicAccess"]),
	}
}
