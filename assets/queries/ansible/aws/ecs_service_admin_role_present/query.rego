package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
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

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
