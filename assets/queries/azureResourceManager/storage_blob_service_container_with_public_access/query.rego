package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

publicOptions := {"Container", "Blob"}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts/blobServices/containers"

	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.publicAccess)
	val == publicOptions[o]

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.publicAccess", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Storage/storageAccounts/blobServices/containers' shouldn't have 'publicAccess' %s set to 'Container' or 'Blob'", [val_type]),
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
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, childValue.properties.publicAccess)
	val == publicOptions[o]

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.resources.name=%s.properties.publicAccess", [common_lib.concat_path(path), value.name, childValue.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'containers' shouldn't have 'publicAccess' %s set to 'Container' or 'Blob'",[val_type]),
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
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, childValue.properties.publicAccess)
	val == publicOptions[o]

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
        "searchKey": sprintf("%s.name=%s.resources.name=%s.properties.publicAccess", [common_lib.concat_path(path), value.name, childValue.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'blobServices/containers' shouldn't have 'publicAccess' %s set to 'Container' or 'Blob'", [val_type]),
		"keyActualValue": sprintf("resource with type 'blobServices/containers' has 'publicAccess' property set to '%s'", [publicOptions[o]]),
		"searchLine": common_lib.build_search_line(childPath, ["properties", "publicAccess"]),
	}
}



CxPolicy[result] {
	doc := input.document[i]
    
	[path, value] = walk(doc)
	value.type == "Microsoft.Storage/storageAccounts"

	[childPath, childValue] := walk(value.resources)
	childValue.type == "blobServices"

	[subchildPath, subchildValue] := walk(childValue.resources)
	subchildValue.type == "containers"
    
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, subchildValue.properties.publicAccess)
	val == publicOptions[o]

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
        "searchKey": sprintf("%s.name=%s.resources.name=%s.resources.name=%s.properties.publicAccess", [common_lib.concat_path(path), value.name, childValue.name, subchildValue.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'containers' shouldn't have 'publicAccess' %s set to 'Container' or 'Blob'", [val_type]),
		"keyActualValue": sprintf("resource with type 'containers' has 'publicAccess' property set to '%s'", [publicOptions[o]]),
		"searchLine": common_lib.build_search_line(path, ["resources", childPath[0], "resources", subchildPath[0], "properties", "publicAccess"]),
	}
}