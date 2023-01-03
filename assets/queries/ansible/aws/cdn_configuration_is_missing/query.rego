package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	cloudfront_distribution := task[modules[m]]

	ansLib.checkState(cloudfront_distribution)
	not common_lib.valid_key(cloudfront_distribution, "enabled")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.enabled should be set to 'true'", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.enabled is not set", [task.name, modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	cloudfront_distribution := task[modules[m]]

	ansLib.checkState(cloudfront_distribution)
	ansLib.isAnsibleFalse(cloudfront_distribution.enabled)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.enabled should be set to 'true'", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.enabled is set to '%s'", [task.name, modules[m], cloudfront_distribution.enabled]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	cloudfront_distribution := task[modules[m]]

	ansLib.checkState(cloudfront_distribution)
	not common_lib.valid_key(cloudfront_distribution, "origins")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.origins should be defined", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.origins is not defined", [task.name, modules[m]]),
	}
}
