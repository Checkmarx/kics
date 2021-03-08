package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront := task[modules[m]]
	ansLib.checkState(cloudfront)

	object.get(cloudfront, "logging", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudfront_distribution.logging is defined",
		"keyActualValue": "cloudfront_distribution.logging is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront := task[modules[m]]
	ansLib.checkState(cloudfront)

	not ansLib.isAnsibleTrue(cloudfront.logging.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.logging.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudfront_distribution.logging.enabled is true",
		"keyActualValue": "cloudfront_distribution.logging.enabled is false",
	}
}
