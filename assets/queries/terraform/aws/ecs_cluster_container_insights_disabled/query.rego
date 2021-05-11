package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_cluster[name]

	not container_insights_enabled(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecs_cluster[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ecs_cluster[%s].setting.name' is set to 'containerInsights' and 'aws_ecs_cluster[%s].setting.value' is set to 'enabled'", [name, name]),
		"keyActualValue": sprintf("'aws_ecs_cluster[%s].setting.name' is not set to 'containerInsights' and/or 'aws_ecs_cluster[%s].setting.value' is not set to 'enabled'", [name, name]),
	}
}

container_insights_enabled(resource) {
	resource.setting.value == "enabled"
}
