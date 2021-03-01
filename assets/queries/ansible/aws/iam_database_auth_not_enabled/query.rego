package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task["community.aws.rds_instance"]

	ansLib.isAnsibleFalse(rds_instance.enable_iam_database_authentication)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.enable_iam_database_authentication", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}}.enable_iam_database_authentication should be enabled.", [task.name]),
		"keyActualValue": sprintf("{{%s}}.enable_iam_database_authentication is disabled", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task["community.aws.rds_instance"]

	object.get(rds_instance, "enable_iam_database_authentication", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("{{%s}}.enable_iam_database_authentication should be defined", [task.name]),
		"keyActualValue": sprintf("{{%s}}.enable_iam_database_authentication is undefined", [task.name]),
	}
}
