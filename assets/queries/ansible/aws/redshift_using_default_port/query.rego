package Cx

import data.generic.ansible as ans_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"redshift", "community.aws.redshift"}

	task[modules[m]].port == 5439

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.port", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "redshift.port is not set to 5439",
		"keyActualValue": "redshift.port is set to 5439",
	}
}
