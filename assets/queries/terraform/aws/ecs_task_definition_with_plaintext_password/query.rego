package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecs_task_definition[name]

	resourceJson := commonLib.json_unmarshal(resource.container_definitions)
	env := resourceJson.containerDefinitions[_].environment[_]
	contains(lower(env.name), "password")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecs_task_definition",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s", [env.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'container_definitions.environment.name' shouldn't have password value",
		"keyActualValue": "'container_definitions.environment.name' has password value",
	}
}
