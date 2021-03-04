package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["community.aws.rds_instance"]

	object.get(instance, "backup_retention_period", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.rds_instance should have the property 'backup_retention_period' greater than 0",
		"keyActualValue": "community.aws.rds_instance has the property 'backup_retention_period' unassigned",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["community.aws.rds_instance"]

	instance.backup_retention_period == 0

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}.backup_retention_period", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.rds_instance should have the property 'backup_retention_period' greater than 0",
		"keyActualValue": "community.aws.rds_instance has the property 'backup_retention_period' assigned to 0",
	}
}
