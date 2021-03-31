package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	lower(resource.network_mode) != "awsvpc"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecs_task_definition[%s].network_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'network_mode' is equal to 'awsvpc'",
		"keyActualValue": sprintf("'network_mode' is equal to '%s'", [resource.network_mode]),
	}
}
