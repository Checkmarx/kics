package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	modules := {"community.aws.cloudtrail", "cloudtrail"}
	object.get(task[modules[index]], "enable_log_file_validation", "undefined") == "undefined"
	object.get(task[modules[index]], "log_file_validation_enabled", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.enable_log_file_validation or %s.log_file_validation_enabled is defined", [modules[index], modules[index]]),
		"keyActualValue": sprintf("%s.enable_log_file_validation and %s.log_file_validation_enabled are undefined", [modules[index], modules[index]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}
	attributes := {"enable_log_file_validation", "log_file_validation_enabled"}

	attr := object.get(task[modules[index]], attributes[j], "undefined")
	attr != "undefined"
	not ansLib.isAnsibleTrue(attr)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{%s}}.%s", [task.name, modules[index], attributes[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.%s is set to true or yes", [modules[index], attributes[j]]),
		"keyActualValue": sprintf("%s.%s is not set to true or yes", [modules[index], attributes[j]]),
	}
}
