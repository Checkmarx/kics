package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"amazon.aws.cloudformation", "cloudformation", "community.aws.cloudformation_stack_set", "cloudformation_stack_set"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudformation := task[modules[m]]
	ansLib.checkState(cloudformation)

	common_lib.valid_key(cloudformation, "template_body") == false
	common_lib.valid_key(cloudformation, "template_url") == false
	common_lib.valid_key(cloudformation, "template") == false

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s has template, template_body or template_url set", [modules[m]]),
		"keyActualValue": sprintf("%s does not have template, template_body or template_url set", [modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudformation := task[modules[m]]
	ansLib.checkState(cloudformation)
	attributes := {"template_body", "template_url", "template"}
	count([x | template := attributes[x]; common_lib.valid_key(cloudformation, template)]) > 1
	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s should not have more than one of the attributes template, template_body and template_url set", [modules[m]]),
		"keyActualValue": sprintf("%s has more than one of the attributes template, template_body and template_url set", [modules[m]]),
	}
}
