package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.cloudtrail", "cloudtrail"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)

	not common_lib.valid_key(cloudtrail, "enable_log_file_validation")
	not common_lib.valid_key(cloudtrail, "log_file_validation_enabled")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudtrail.enable_log_file_validation or cloudtrail.log_file_validation_enabled should be defined",
		"keyActualValue": "cloudtrail.enable_log_file_validation and cloudtrail.log_file_validation_enabled are undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudtrail := task[modules[m]]
	ansLib.checkState(cloudtrail)
	attributes := {"enable_log_file_validation", "log_file_validation_enabled"}

	attr := attributes[j]
	common_lib.valid_key(cloudtrail, attr)
	not ansLib.isAnsibleTrue(cloudtrail[attr])

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], attr]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("cloudtrail.%s should be set to true or yes", [attr]),
		"keyActualValue": sprintf("cloudtrail.%s is not set to true nor yes", [attr]),
	}
}
