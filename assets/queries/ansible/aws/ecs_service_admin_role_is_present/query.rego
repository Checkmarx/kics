package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	ecs := task["community.aws.ecs_service"]
	ecsName := task.name

	is_string(ecs.role)
	contains(lower(ecs.role), "admin")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.ecs_service}}.role", [ecsName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.ecs_service.role is not an admin role",
		"keyActualValue": "community.aws.ecs_service.role is an admin role",
	}
}