package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.ContainerService/managedClusters"

	not common_lib.valid_key(value.properties, "enableRBAC")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.ContainerService/managedClusters' has the 'enableRBAC' property defined",
		"keyActualValue": "resource with type 'Microsoft.ContainerService/managedClusters' doesn't have 'enableRBAC' property defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.ContainerService/managedClusters"

	value.properties.enableRBAC == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name={{%s}}.properties.enableRBAC", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.ContainerService/managedClusters' has the 'enableRBAC' property set to true",
		"keyActualValue": "resource with type 'Microsoft.ContainerService/managedClusters' doesn't have 'enableRBAC' set to true",
	}
}
