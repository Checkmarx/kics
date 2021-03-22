package Cx

import data.generic.ansible as ansLib

modules := {"amazon.aws.cloudformation", "cloudformation", "community.aws.cloudformation_stack_set", "cloudformation_stack_set"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudformation := task[modules[m]]
	ansLib.checkState(cloudformation)

	object.get(cloudformation, "template_body", "undefined") == "undefined"
	object.get(cloudformation, "template_url", "undefined") == "undefined"
	object.get(cloudformation, "template", "undefined") == "undefined"

	result := {
		"documentId": id,
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

	count([x | obj := object.get(cloudformation, attributes[x], "undefined"); obj != "undefined"]) > 1

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s does not have more than one of the attributes template, template_body and template_url set", [modules[m]]),
		"keyActualValue": sprintf("%s has more than one of the attributes template, template_body and template_url set", [modules[m]]),
	}
}
