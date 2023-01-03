package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.ContainerService/managedClusters"

	not common_lib.valid_key(value.properties, "enableRBAC")

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.ContainerService/managedClusters' should have the 'enableRBAC' property defined",
		"keyActualValue": "resource with type 'Microsoft.ContainerService/managedClusters' doesn't have 'enableRBAC' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.ContainerService/managedClusters"

	[enableRBAC_value, enableRBAC_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.enableRBAC)
	enableRBAC_value == false

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.enableRBAC", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.ContainerService/managedClusters' should have the 'enableRBAC' %s set to true",[enableRBAC_type]),
		"keyActualValue": sprintf("resource with type 'Microsoft.ContainerService/managedClusters' doesn't have 'enableRBAC' set to true",[enableRBAC_type]),
		"searchLine": common_lib.build_search_line(path, ["properties", "enableRBAC"]),
	}
}
