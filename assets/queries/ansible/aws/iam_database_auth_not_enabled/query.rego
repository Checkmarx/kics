package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.rds_instance", "rds_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	ansLib.isAnsibleFalse(rds_instance.enable_iam_database_authentication)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enable_iam_database_authentication", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "rds_instance.enable_iam_database_authentication should be enabled",
		"keyActualValue": "rds_instance.enable_iam_database_authentication is disabled",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	object.get(rds_instance, "enable_iam_database_authentication", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "rds_instance.enable_iam_database_authentication should be defined",
		"keyActualValue": "rds_instance.enable_iam_database_authentication is undefined",
	}
}
