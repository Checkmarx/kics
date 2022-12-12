package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.route53", "route53"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	route53 := task[modules[m]]
	ansLib.checkState(route53)

	not common_lib.valid_key(route53, "value")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "route53.value should be defined or not null",
		"keyActualValue": "route53.value is undefined or null",
	}
}
