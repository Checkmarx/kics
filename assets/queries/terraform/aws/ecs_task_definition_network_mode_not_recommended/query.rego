package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]
	lower(resource.network_mode) != "awsvpc"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_task_definition",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecs_task_definition[%s].network_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'network_mode' is equal to 'awsvpc'",
		"keyActualValue": sprintf("'network_mode' is equal to '%s'", [resource.network_mode]),
	}
}
