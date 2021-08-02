package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.ContainerService/managedClusters"
	not common_lib.valid_key(resource.properties, "enableRBAC")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.ContainerService/managedClusters}}.properties",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.ContainerService/managedClusters' has the 'enableRBAC' property defined",
		"keyActualValue": "resource with type 'Microsoft.ContainerService/managedClusters' doesn't have 'enableRBAC' property defined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.ContainerService/managedClusters"
	resource.properties.enableRBAC == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.ContainerService/managedClusters}}.properties.enableRBAC",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.ContainerService/managedClusters' has the 'enableRBAC' property set to true",
		"keyActualValue": "resource with type 'Microsoft.ContainerService/managedClusters' doesn't have 'enableRBAC' set to true",
	}
}
