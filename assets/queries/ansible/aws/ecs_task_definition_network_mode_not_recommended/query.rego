package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.ecs_taskdefinition"].network_mode != "awsvpc"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_taskdefinition}}.network_mode", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'community.aws.ecs_taskdefinition.network_mode' is 'awsvpc'",
		"keyActualValue": sprintf("'community.aws.ecs_taskdefinition.network_mode' is '%s'", [task["community.aws.ecs_taskdefinition"].network_mode]),
	}
}
