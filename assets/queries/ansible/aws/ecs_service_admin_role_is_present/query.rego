package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ecs_service", "ecs_service"}
	ecs := task[modules[m]]
	ansLib.checkState(ecs)

	is_string(ecs.role)
	contains(lower(ecs.role), "admin")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.role", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ecs_service.role should not be an admin role",
		"keyActualValue": "ecs_service.role is an admin role",
	}
}
