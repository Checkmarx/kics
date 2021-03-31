package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"community.aws.route53", "route53"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	route53 := task[modules[m]]
	ansLib.checkState(route53)

	object.get(route53, "value", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "route53.value is defined",
		"keyActualValue": "route53.value is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	route53 := task[modules[m]]
	ansLib.checkState(route53)

	commonLib.emptyOrNull(route53.value)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.value", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "route53.value is not empty",
		"keyActualValue": "route53.value is empty",
	}
}
