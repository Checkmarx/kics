package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ecs := task["community.aws.ecs_service"]

	is_string(ecs.role)
	contains(lower(ecs.role), "admin")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.ecs_service}}.role", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.ecs_service.role is not an admin role",
		"keyActualValue": "community.aws.ecs_service.role is an admin role",
	}
}
