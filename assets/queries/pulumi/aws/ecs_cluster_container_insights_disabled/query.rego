package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:ecs:Cluster"

	not common_lib.valid_key(resource.properties, "settings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'settings' should be defined and have a ClusterSetting named 'containerInsights' which value is 'enabled'",
		"keyActualValue": "Attribute 'settings' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:ecs:Cluster"

	not containerInsights(resource.properties.settings)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.settings", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'settings' should have a ClusterSetting named 'containerInsights' which value is 'enabled'",
		"keyActualValue": "Attribute 'settings' doesn't have a ClusterSetting named 'containerInsights' which value is 'enabled'",
		"searchLine": common_lib.build_search_line(["resources", name, "properties","settings"], []),
	}
}

containerInsights(settings){
	settings[0].name == "containerInsights"
	settings[0].value == "enabled"
}