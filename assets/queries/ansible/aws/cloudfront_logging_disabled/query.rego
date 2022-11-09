package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront := task[modules[m]]
	ansLib.checkState(cloudfront)

	not common_lib.valid_key(cloudfront, "logging")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudfront_distribution.logging should be defined",
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.logging.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudfront_distribution.logging.enabled should be true",
		"keyActualValue": "cloudfront_distribution.logging.enabled is false",
	}
}
