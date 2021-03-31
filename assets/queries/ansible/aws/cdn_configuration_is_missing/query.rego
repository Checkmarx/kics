package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	cloudfront_distribution := task[modules[m]]

	ansLib.checkState(cloudfront_distribution)
	object.get(cloudfront_distribution, "enabled", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.enabled is set to 'true'", [task.name, modules[m]]),
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
		"searchKey": sprintf("name={{%s}}.{{%s}}.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.enabled is set to 'true'", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.enabled is set to '%s'", [task.name, modules[m], cloudfront_distribution.enabled]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	cloudfront_distribution := task[modules[m]]

	ansLib.checkState(cloudfront_distribution)
	object.get(cloudfront_distribution, "origins", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.origins is defined", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.origins is not defined", [task.name, modules[m]]),
	}
}
