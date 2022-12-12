package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudformation_stack_set",}
	cloudformation_stack_set := task[modules[m]]
	ansLib.checkState(cloudformation_stack_set)

	not common_lib.valid_key(cloudformation_stack_set, "purge_stacks")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudformation_stack_set.purge_stacks should be set",
		"keyActualValue": "cloudformation_stack_set.purge_stacks is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudformation_stack_set"}
	cloudformation_stack_set := task[modules[m]]
	ansLib.checkState(cloudformation_stack_set)

	common_lib.valid_key(cloudformation_stack_set, "purge_stacks")

    cloudformation_stack_set.purge_stacks

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.purge_stacks", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudformation_stack_set.purge_stacks should be set to false",
		"keyActualValue": "cloudformation_stack_set.purge_stacks is true",
	}
}
