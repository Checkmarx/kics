package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::Cluster"

	not common_lib.valid_key(elem.Properties, "ClusterSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ClusterSettings should be defined and have a ClusterSetting named containerInsights which value is 'enabled'", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.ClusterSettings is not defined", [key]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::Cluster"

	taskDefinitionList := elem.Properties.ClusterSettings

	not container_insights(taskDefinitionList)

	result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.ClusterSettings", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ClusterSettings should have a ClusterSetting named 'containerInsights' which value is 'enabled'", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.ClusterSettings hasn't got a ClusterSetting named 'containerInsights' which value is 'enabled'", [key]),
	}
}

container_insights(settings){
	settings[0].name == "containerInsights"
	settings[0].value == "enabled"
}