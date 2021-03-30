package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudformation_stack_set",}
	cloudformation_stack_set := task[modules[m]]
	ansLib.checkState(cloudformation_stack_set)

	object.get(cloudformation_stack_set, "purge_stacks", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudformation_stack_set.purge_stacks is set",
		"keyActualValue": "cloudformation_stack_set.purge_stacks is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudformation_stack_set"}
	cloudformation_stack_set := task[modules[m]]
	ansLib.checkState(cloudformation_stack_set)

	object.get(cloudformation_stack_set, "purge_stacks", "undefined") != "undefined"

    cloudformation_stack_set.purge_stacks

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.purge_stacks", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudformation_stack_set.purge_stacks is false",
		"keyActualValue": "cloudformation_stack_set.purge_stacks is true",
	}
}
