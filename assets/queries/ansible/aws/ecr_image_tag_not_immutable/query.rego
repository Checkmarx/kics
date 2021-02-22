package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
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
	tasks := ansLib.getTasks(document)
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
