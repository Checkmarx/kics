package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.ecs_ecr", "ecs_ecr"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ecs_ecr := task[modules[m]]
	ansLib.checkState(ecs_ecr)

	not common_lib.valid_key(ecs_ecr, "image_tag_mutability")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ecs_ecr.image_tag_mutability should be set ",
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.image_tag_mutability", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ecs_ecr.image_tag_mutability should be set to 'immutable'",
		"keyActualValue": "ecs_ecr.image_tag_mutability is not set to 'immutable'",
	}
}
