package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.ecs_ecr", "ecs_ecr"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ecs_ecr := task[modules[m]]
	ansLib.checkState(ecs_ecr)

	object.get(ecs_ecr, "image_tag_mutability", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ecs_ecr.image_tag_mutability is set ",
		"keyActualValue": "ecs_ecr.image_tag_mutability is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ecs_ecr := task[modules[m]]
	ansLib.checkState(ecs_ecr)

	ecs_ecr.image_tag_mutability != "immutable"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.image_tag_mutability", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ecs_ecr.image_tag_mutability is set to 'immutable'",
		"keyActualValue": "ecs_ecr.image_tag_mutability is not set to 'immutable'",
	}
}
