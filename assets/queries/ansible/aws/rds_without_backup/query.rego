package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	instance := task["community.aws.rds_instance"]
	instanceName := task.name

	object.get(instance, "backup_retention_period", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}", [instanceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.rds_instance should have the property 'backup_retention_period' greater than 0",
		"keyActualValue": "community.aws.rds_instance has the property 'backup_retention_period' unassigned",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	instance := task["community.aws.rds_instance"]
	instanceName := task.name

	instance.backup_retention_period == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}.backup_retention_period", [instanceName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.rds_instance should have the property 'backup_retention_period' greater than 0",
		"keyActualValue": "community.aws.rds_instance has the property 'backup_retention_period' assigned to 0",
	}
}