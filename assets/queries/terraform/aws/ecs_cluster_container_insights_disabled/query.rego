package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_cluster[name]

	not container_insights_enabled(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_cluster[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ecs_cluster[%s].setting.name' should be set to 'containerInsights' and 'aws_ecs_cluster[%s].setting.value' should be set to 'enabled'", [name, name]),
		"keyActualValue": sprintf("'aws_ecs_cluster[%s].setting.name' is not set to 'containerInsights' and/or 'aws_ecs_cluster[%s].setting.value' is not set to 'enabled'", [name, name]),
	}
}

container_insights_enabled(resource) {
	resource.setting.value == "enabled"
}
