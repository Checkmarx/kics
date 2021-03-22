package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ecs_taskdefinition", "ecs_taskdefinition"}
	ecs_taskdefinition := task[modules[m]]
	ansLib.checkState(ecs_taskdefinition)

	ecs_taskdefinition.network_mode != "awsvpc"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_mode", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ecs_taskdefinition.network_mode' is 'awsvpc'",
		"keyActualValue": sprintf("'ecs_taskdefinition.network_mode' is '%s'", [ecs_taskdefinition.network_mode]),
	}
}
