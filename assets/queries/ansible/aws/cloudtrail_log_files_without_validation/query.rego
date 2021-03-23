package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.cloudtrail", "cloudtrail"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)

	object.get(cloudtrail, "enable_log_file_validation", "undefined") == "undefined"
	object.get(cloudtrail, "log_file_validation_enabled", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudtrail.enable_log_file_validation or cloudtrail.log_file_validation_enabled is defined",
		"keyActualValue": "cloudtrail.enable_log_file_validation and cloudtrail.log_file_validation_enabled are undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)
	attributes := {"enable_log_file_validation", "log_file_validation_enabled"}

	attr := object.get(cloudtrail, attributes[j], "undefined")
	attr != "undefined"
	not ansLib.isAnsibleTrue(attr)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], attributes[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("cloudtrail.%s is set to true or yes", [attributes[j]]),
		"keyActualValue": sprintf("cloudtrail.%s is not set to true nor yes", [attributes[j]]),
	}
}
