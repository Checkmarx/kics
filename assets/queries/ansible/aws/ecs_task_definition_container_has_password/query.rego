package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cont := task["community.aws.ecs_taskdefinition"].containers[j]
	password := ["password", "pw", "pass"]

	checkPassword(cont.env, password)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_taskdefinition}}.containers.name={{%s}}.env", [task.name, cont.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'community.aws.ecs_taskdefinition.containers.env' doesn't have 'password' value",
		"keyActualValue": "'community.aws.ecs_taskdefinition.containers.env' has 'password' value",
	}
}

checkPassword(env, password) {
	key := [x | env[idx][j]; upper(j) == upper(password[_]); x = j]
	count(key) > 0
}
