package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.rds_instance", "rds_instance", "community.aws.rds", "rds"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	not ansLib.isAnsibleTrue(rds_instance.multi_az)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.multi_az", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [modules[m]]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' has MultiAZ value set to false", [modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	not common_lib.valid_key(rds_instance, "multi_az")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.multi_az", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [modules[m]]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' MultiAZ property is undefined and by default disabled", [modules[m]]),
	}
}
