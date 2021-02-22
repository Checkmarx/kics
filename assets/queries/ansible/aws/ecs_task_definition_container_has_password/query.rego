package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	password := ["password", "pw", "pass"]
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	cont := task["community.aws.ecs_taskdefinition"].containers[j]
	checkPassword(cont.env, password)

	result := {
		"documentId": document.id,
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
