package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.ecs_ecr", "ecs_ecr"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs := task[modules[m]]
	ansLib.checkState(cloudwatchlogs)

	re_match("\\*", cloudwatchlogs.policy.Statement[index].Principal)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ecs_ecr.policy.Principal is not equal to '*'",
		"keyActualValue": "ecs_ecr.policy.Principal is equal to '*'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs := task[modules[m]]
	ansLib.checkState(cloudwatchlogs)

	re_match("\"Principal\"\\ *:\\ *\"\\*\"", cloudwatchlogs.policy)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ecs_ecr.policy.Principal is not equal '*'",
		"keyActualValue": "ecs_ecr.policy.Principal is equal '*'",
	}
}
