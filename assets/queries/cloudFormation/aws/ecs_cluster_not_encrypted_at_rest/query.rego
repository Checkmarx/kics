package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::Service"
	clustername := elem.Properties.Cluster
	taskdefinitionkey := elem.Properties.TaskDefinition
	taskDefinition := resource[taskdefinitionkey]

	count(taskDefinition.Properties.ContainerDefinitions) > 0
	taskDefinition.Properties.Volumes[j].EFSVolumeConfiguration.TransitEncryption == "DISABLED"

	result := {
		"documentId": document.id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.Volumes", [taskdefinitionkey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption should be enabled", [taskdefinitionkey, j]),
		"keyActualValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption is disabled", [taskdefinitionkey, j]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::Service"
	clustername := elem.Properties.Cluster
	taskdefinitionkey := elem.Properties.TaskDefinition
	not common_lib.valid_key(resource, taskdefinitionkey)

	result := {
		"documentId": document.id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s", [taskdefinitionkey]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s should be defined", [taskdefinitionkey]),
		"keyActualValue": sprintf("Resources.%s is not defined.", [taskdefinitionkey]),
	}
}
