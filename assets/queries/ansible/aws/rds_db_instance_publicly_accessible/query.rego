package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.rds_instance", "rds_instance", "community.aws.rds", "rds"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	ansLib.isAnsibleTrue(rds_instance.publicly_accessible)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.publicly_accessible", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.publicly_accessible should be false", [modules[m]]),
		"keyActualValue": sprintf("%s.publicly_accessible is true", [modules[m]]),
	}
}
