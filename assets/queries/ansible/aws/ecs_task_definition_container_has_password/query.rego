package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ecs_taskdefinition", "ecs_taskdefinition"}
	ecs_taskdefinition := task[modules[m]]
	ansLib.checkState(ecs_taskdefinition)

	container := ecs_taskdefinition.containers[j]
	password := ["password", "pw", "pass"]
	checkPassword(container.env, password)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.containers.name={{%s}}.env", [task.name, modules[m], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ecs_taskdefinition.containers.env' doesn't have 'password' value",
		"keyActualValue": "'ecs_taskdefinition.containers.env' has 'password' value",
	}
}

checkPassword(env, password) {
	key := [x | env[idx][j]; upper(j) == upper(password[_]); x = j]
	count(key) > 0
}
