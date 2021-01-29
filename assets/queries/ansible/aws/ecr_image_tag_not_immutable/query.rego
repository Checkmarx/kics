package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task["community.aws.ecs_ecr"], "image_tag_mutability", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.ecs_ecr.image_tag_mutability is set ",
		"keyActualValue": "community.aws.ecs_ecr.image_tag_mutability is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	task["community.aws.ecs_ecr"].image_tag_mutability != "immutable"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.image_tag_mutability", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.ecs_ecr.image_tag_mutability is set to 'immutable'",
		"keyActualValue": "community.aws.ecs_ecr.image_tag_mutability is not set to 'immutable'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
