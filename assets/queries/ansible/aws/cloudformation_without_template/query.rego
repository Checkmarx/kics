package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	modules := {"community.aws.cloudformation_stack_set", "amazon.aws.cloudformation"}

	object.get(task[modules[index]], "template_body", "undefined") == "undefined"
	object.get(task[modules[index]], "template_url", "undefined") == "undefined"
	object.get(task[modules[index]], "template", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s has template, template_body or template_url set", [modules[index]]),
		"keyActualValue": sprintf("%s does not have template, template_body or template_url set", [modules[index]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	attributes := {"template_body", "template_url", "template"}

	modules := {"community.aws.cloudformation_stack_set", "amazon.aws.cloudformation"}

	count([x | obj := object.get(task[modules[index]], attributes[x], "undefined"); obj != "undefined"]) > 1

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s does not have more than one of the attributes template, template_body and template_url set", [modules[index]]),
		"keyActualValue": sprintf("%s has more than one of the attributes template, template_body and template_url set", [modules[index]]),
	}
}