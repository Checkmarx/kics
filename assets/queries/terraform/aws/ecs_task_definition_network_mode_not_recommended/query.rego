package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	networkMode := resource.network_mode
	networkMode != "awsvpc"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s", [networkMode]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'network_mode' is equal 'awsvpc'",
		"keyActualValue": sprintf("'network_mode' is equal '%s'", [networkMode]),
	}
}
