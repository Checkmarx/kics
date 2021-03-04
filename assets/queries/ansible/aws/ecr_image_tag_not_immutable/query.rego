package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["community.aws.ecs_ecr"], "image_tag_mutability", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.ecs_ecr.image_tag_mutability is set ",
		"keyActualValue": "community.aws.ecs_ecr.image_tag_mutability is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.ecs_ecr"].image_tag_mutability != "immutable"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.image_tag_mutability", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.ecs_ecr.image_tag_mutability is set to 'immutable'",
		"keyActualValue": "community.aws.ecs_ecr.image_tag_mutability is not set to 'immutable'",
	}
}
