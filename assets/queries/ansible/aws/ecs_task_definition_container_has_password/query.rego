package Cx

CxPolicy[result] {
	password := ["password", "pw", "pass"]
	document := input.document[i]
	tasks := getTasks(document)
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

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

checkPassword(env, password) {
	key := [x | env[idx][j]; upper(j) == upper(password[_]); x = j]
	count(key) > 0
}
